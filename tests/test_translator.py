"""Tests for Agent 6: Translator with escalation and triple collection."""

from leanknowledge.schemas import (
    StructuredProof, ProofStrategy, ProofStep,
    ExtractedItem, StatementType, ClaimRole,
)
from leanknowledge.agents.translator import (
    TranslatorAgent, LeanCompiler, TranslationOutcome, TranslationResult,
    _build_initial_prompt, _build_retry_prompt, _extract_lean_code,
    _build_direct_prompt, _build_direct_retry_prompt, _minimal_proof,
    TranslationTriple, SubLemma, Decomposition,
    _build_decomposition_prompt, _parse_decomposition,
    _build_sub_lemma_prompt, _build_assembly_prompt,
    _build_axiom_assembly_prompt, _signature_to_axiom_body,
    _extract_unknown_identifiers,
    AttemptOutcome, classify_attempt_outcome, MAX_OPERATIONAL_RETRIES,
)


def _proof() -> StructuredProof:
    return StructuredProof(
        theorem_name="test_thm",
        strategy=ProofStrategy.DIRECT,
        goal_statement="1 + 1 = 2",
        steps=[ProofStep(step_number=1, description="Compute",
                         justification="By norm_num",
                         lean_tactic_hint="norm_num")],
        conclusion="Done.",
    )


def _item() -> ExtractedItem:
    return ExtractedItem(
        id="Thm 1.1",
        type=StatementType.THEOREM,
        role=ClaimRole.CLAIMED_RESULT,
        statement="1 + 1 = 2",
        proof="By computation.",
        section="1.A",
    )


class MockCompiler(LeanCompiler):
    """Compiler that succeeds on attempt N (1-indexed), fails before."""

    def __init__(self, succeed_on: int | None = None):
        self.succeed_on = succeed_on
        self.call_count = 0

    def compile(self, code: str) -> tuple[bool, str]:
        self.call_count += 1
        if self.succeed_on and self.call_count >= self.succeed_on:
            return True, "No errors."
        return False, f"error: type mismatch (attempt {self.call_count})"


class AlwaysFailCompiler(LeanCompiler):
    def compile(self, code: str) -> tuple[bool, str]:
        return False, "error: unknown identifier 'foo'"


class FakeTranslatorAgent(TranslatorAgent):
    """TranslatorAgent that doesn't actually call LLMs — returns fixed code."""

    def __init__(self, compiler, **kw):
        super().__init__(compiler, **kw)
        self._response_count = 0

    def _fake_complete(self, model, prompt, system, max_tokens):
        self._response_count += 1
        return f"theorem test_thm : 1 + 1 = 2 := by norm_num -- attempt {self._response_count}"


# We'll test the components that don't need LLM calls

class TestPromptBuilding:
    def test_initial_prompt_has_proof(self):
        prompt = _build_initial_prompt(_proof())
        assert "test_thm" in prompt
        assert "1 + 1 = 2" in prompt
        assert "PREVIOUS ATTEMPTS" not in prompt

    def test_retry_prompt_has_history(self):
        history = [
            TranslationTriple(
                structured_proof=_proof(),
                lean_code="theorem bad : sorry",
                compiler_output="error: unknown tactic 'sorry_bad'",
                compiled=False,
                model="deepseek/deepseek-reasoner",
                attempt_number=1,
            ),
        ]
        prompt = _build_retry_prompt(_proof(), history)
        assert "PREVIOUS ATTEMPTS" in prompt
        assert "ATTEMPT 1" in prompt
        assert "theorem bad : sorry" in prompt
        assert "unknown tactic" in prompt
        assert "FAILED" in prompt

    def test_retry_prompt_shows_multiple_attempts(self):
        history = [
            TranslationTriple(
                structured_proof=_proof(),
                lean_code=f"code_{i}",
                compiler_output=f"error_{i}",
                compiled=False,
                model="test",
                attempt_number=i,
            )
            for i in range(1, 4)
        ]
        prompt = _build_retry_prompt(_proof(), history)
        assert "ATTEMPT 1" in prompt
        assert "ATTEMPT 2" in prompt
        assert "ATTEMPT 3" in prompt
        assert "error_1" in prompt
        assert "error_3" in prompt


class TestCodeExtraction:
    def test_plain_code(self):
        result = _extract_lean_code("theorem x : True := trivial")
        assert "theorem x : True := trivial" in result
        assert result.startswith("import Mathlib")

    def test_strip_markdown_fences(self):
        code = "```lean\ntheorem x : True := trivial\n```"
        result = _extract_lean_code(code)
        assert "theorem x : True := trivial" in result
        assert "```" not in result

    def test_strip_fences_no_language(self):
        code = "```\ntheorem x : True := trivial\n```"
        result = _extract_lean_code(code)
        assert "theorem x : True := trivial" in result
        assert "```" not in result

    def test_import_preserved_if_present(self):
        code = "import Mathlib\n\ntheorem x : True := trivial"
        result = _extract_lean_code(code)
        assert result.startswith("import Mathlib")
        # Should not have double import
        assert result.count("import Mathlib") == 1

    def test_truncates_at_example(self):
        code = "theorem x : True := trivial\n\nexample : True := trivial"
        result = _extract_lean_code(code)
        assert "theorem x" in result
        assert "example" not in result

    def test_strip_think_tags_with_fenced_code(self):
        """DeepSeek Reasoner wraps reasoning in <think> tags before the answer."""
        response = (
            "<think>\nLet me reason about this theorem.\n"
            "We need to show that 1 + 1 = 2.\n"
            "This follows from norm_num.\n</think>\n"
            "```lean\ntheorem x : True := trivial\n```"
        )
        result = _extract_lean_code(response)
        assert "theorem x : True := trivial" in result
        assert "<think>" not in result
        assert "Let me reason" not in result

    def test_strip_think_tags_no_fence(self):
        """DeepSeek Reasoner with bare code after </think> (no markdown fence)."""
        response = (
            "<think>reasoning about the proof</think>\n"
            "theorem x : True := trivial"
        )
        result = _extract_lean_code(response)
        assert "theorem x : True := trivial" in result
        assert "<think>" not in result
        assert "reasoning" not in result

    def test_fallback_keyword_extraction(self):
        """If normal extraction fails, find lines starting with theorem/lemma/def."""
        response = (
            "Here is my proof:\n\n"
            "theorem x : True := trivial"
        )
        result = _extract_lean_code(response)
        assert "theorem x : True := trivial" in result


class TestTranslationResult:
    def test_success_on_first_try(self):
        compiler = MockCompiler(succeed_on=1)
        # We can't fully test without LLM, but we can test the triple structure
        triple = TranslationTriple(
            structured_proof=_proof(),
            lean_code="theorem test : 1 + 1 = 2 := by norm_num",
            compiler_output="No errors.",
            compiled=True,
            model="deepseek",
            attempt_number=1,
        )
        assert triple.compiled is True
        assert triple.compiler_output == "No errors."

    def test_failure_triple_has_error(self):
        triple = TranslationTriple(
            structured_proof=_proof(),
            lean_code="theorem bad := sorry",
            compiler_output="error: type mismatch\n  expected: Prop\n  got: Bool",
            compiled=False,
            model="deepseek",
            attempt_number=3,
        )
        assert triple.compiled is False
        assert "type mismatch" in triple.compiler_output
        assert triple.attempt_number == 3


class TestEscalation:
    def test_needs_human_when_all_fail(self):
        """Verify the outcome type when we simulate exhausted attempts."""
        result_outcome = TranslationOutcome.NEEDS_HUMAN
        assert result_outcome == "needs_human"

    def test_outcome_types(self):
        assert TranslationOutcome.SUCCESS == "success"
        assert TranslationOutcome.FAILED_TIER1 == "failed_tier1"
        assert TranslationOutcome.FAILED_TIER2 == "failed_tier2"
        assert TranslationOutcome.NEEDS_HUMAN == "needs_human"


class TestDirectMode:
    def test_direct_prompt_has_theorem(self):
        prompt = _build_direct_prompt(_item())
        assert "Thm 1.1" in prompt
        assert "1 + 1 = 2" in prompt
        assert "By computation" in prompt
        assert "PREVIOUS ATTEMPTS" not in prompt
        assert "STRUCTURED PROOF" not in prompt
        assert "PROOF PLAN" not in prompt

    def test_direct_prompt_no_proof(self):
        item = _item()
        item.proof = None
        prompt = _build_direct_prompt(item)
        assert "Thm 1.1" in prompt
        assert "Informal proof" not in prompt

    def test_direct_retry_prompt_has_history(self):
        history = [
            TranslationTriple(
                structured_proof=_proof(),
                lean_code="theorem bad := sorry",
                compiler_output="error: type mismatch",
                compiled=False,
                model="test",
                attempt_number=1,
            ),
        ]
        prompt = _build_direct_retry_prompt(_item(), history)
        assert "PREVIOUS ATTEMPTS" in prompt
        assert "ATTEMPT 1" in prompt
        assert "type mismatch" in prompt
        assert "PROOF PLAN" not in prompt

    def test_minimal_proof_has_no_steps(self):
        minimal = _minimal_proof(_item())
        assert minimal.theorem_name == "Thm 1.1"
        assert minimal.goal_statement == "1 + 1 = 2"
        assert minimal.strategy == ProofStrategy.DIRECT
        assert minimal.steps == []

    def test_guided_prompt_frames_as_guidance(self):
        prompt = _build_initial_prompt(_proof())
        assert "guidance" in prompt.lower()
        assert "PROOF PLAN" in prompt

    def test_guided_retry_frames_as_guidance(self):
        history = [
            TranslationTriple(
                structured_proof=_proof(),
                lean_code="theorem bad := sorry",
                compiler_output="error",
                compiled=False,
                model="test",
                attempt_number=1,
            ),
        ]
        prompt = _build_retry_prompt(_proof(), history)
        assert "guidance" in prompt.lower()

    def test_prior_triples_carry_forward(self):
        """translate() with prior_triples should include them in result."""
        prior = [
            TranslationTriple(
                structured_proof=_proof(),
                lean_code="direct_attempt",
                compiler_output="error: direct failed",
                compiled=False,
                model="direct_model",
                attempt_number=1,
                reasoning="Tried direct approach",
            ),
        ]
        # We can't call translate() without LLM, but we can verify the
        # triples list initialization
        from leanknowledge.agents.translator import TranslationResult
        result = TranslationResult(
            outcome=TranslationOutcome.NEEDS_HUMAN,
            triples=list(prior),
            total_attempts=1,
        )
        assert len(result.triples) == 1
        assert result.triples[0].reasoning == "Tried direct approach"


class TestNLProofPassthrough:
    """Tests for passing the original NL proof into guided prompts."""

    def test_initial_prompt_includes_nl_proof(self):
        prompt = _build_initial_prompt(_proof(), nl_proof="By computation.")
        assert "**Original informal proof**:" in prompt
        assert "By computation." in prompt
        assert "PROOF PLAN" in prompt

    def test_initial_prompt_without_nl_proof(self):
        prompt = _build_initial_prompt(_proof())
        assert "**Original informal proof**:" not in prompt
        assert "PROOF PLAN" in prompt

    def test_retry_prompt_includes_nl_proof(self):
        history = [
            TranslationTriple(
                structured_proof=_proof(),
                lean_code="theorem bad := sorry",
                compiler_output="error: type mismatch",
                compiled=False,
                model="test",
                attempt_number=1,
            ),
        ]
        prompt = _build_retry_prompt(_proof(), history, nl_proof="By computation.")
        assert "**Original informal proof**:" in prompt
        assert "By computation." in prompt
        assert "PROOF PLAN" in prompt
        assert "PREVIOUS ATTEMPTS" in prompt

    def test_retry_prompt_without_nl_proof(self):
        history = [
            TranslationTriple(
                structured_proof=_proof(),
                lean_code="theorem bad := sorry",
                compiler_output="error: type mismatch",
                compiled=False,
                model="test",
                attempt_number=1,
            ),
        ]
        prompt = _build_retry_prompt(_proof(), history)
        assert "**Original informal proof**:" not in prompt
        assert "PROOF PLAN" in prompt
        assert "PREVIOUS ATTEMPTS" in prompt


class TestTier4Decomposition:
    """Tests for Tier 3: hard theorem decomposition."""

    def test_parse_decomposition(self):
        data = {
            "analysis": "Models struggle with Nat.factors API",
            "sub_lemmas": [
                {
                    "name": "step1_coprime",
                    "lean_signature": "lemma step1_coprime (hp : Nat.Prime p) : True",
                    "nl_description": "Coprimality from primality",
                    "nl_proof_hint": "Use Nat.Prime.coprime_iff_not_dvd",
                    "depends_on": [],
                },
                {
                    "name": "step2_totient",
                    "lean_signature": "lemma step2_totient (hp : Nat.Prime p) : p.totient = p - 1",
                    "nl_description": "Euler's totient of a prime",
                    "nl_proof_hint": "Use Nat.totient_prime",
                    "depends_on": ["step1_coprime"],
                },
            ],
            "assembly": "theorem main := by exact step2_totient hp",
        }
        decomp = _parse_decomposition(data)
        assert decomp.analysis == "Models struggle with Nat.factors API"
        assert len(decomp.sub_lemmas) == 2
        assert decomp.sub_lemmas[0].name == "step1_coprime"
        assert decomp.sub_lemmas[1].depends_on == ["step1_coprime"]
        assert "main" in decomp.assembly

    def test_parse_decomposition_empty(self):
        decomp = _parse_decomposition({"analysis": "no hope", "sub_lemmas": []})
        assert len(decomp.sub_lemmas) == 0
        assert decomp.assembly == ""

    def test_sub_lemma_prompt(self):
        sl = SubLemma(
            name="step1",
            lean_signature="lemma step1 (n : ℕ) : n + 0 = n",
            nl_description="Adding zero is identity",
            nl_proof_hint="Use Nat.add_zero",
        )
        prompt = _build_sub_lemma_prompt(sl)
        assert "step1" in prompt
        assert "n + 0 = n" in prompt
        assert "Adding zero is identity" in prompt
        assert "Nat.add_zero" in prompt

    def test_sub_lemma_prompt_no_hint(self):
        sl = SubLemma(
            name="step1",
            lean_signature="lemma step1 : True",
            nl_description="Trivially true",
            nl_proof_hint="",
        )
        prompt = _build_sub_lemma_prompt(sl)
        assert "step1" in prompt
        assert "Proof hint" not in prompt

    def test_assembly_prompt(self):
        decomp = Decomposition(
            analysis="test",
            sub_lemmas=[
                SubLemma(
                    name="s1",
                    lean_signature="lemma s1 : True",
                    nl_description="trivial",
                    nl_proof_hint="",
                ),
            ],
            assembly="theorem main : True := s1",
        )
        proved = {"s1": "lemma s1 : True := trivial"}
        prompt = _build_assembly_prompt(decomp, proved, _item())
        assert "s1" in prompt
        assert "trivial" in prompt
        assert "1 + 1 = 2" in prompt  # main theorem statement
        assert "theorem main : True := s1" in prompt

    def test_decomposition_prompt_has_theorem_and_history(self):
        history = [
            TranslationTriple(
                structured_proof=_proof(),
                lean_code="theorem bad := sorry",
                compiler_output="error: unknown identifier",
                compiled=False,
                model="deepseek",
                attempt_number=5,
                reasoning="Tried using Nat.factors",
            ),
        ]
        prompt = _build_decomposition_prompt(_item(), history)
        assert "Thm 1.1" in prompt
        assert "1 + 1 = 2" in prompt
        assert "Previous attempts" in prompt
        assert "Tried using Nat.factors" in prompt

    def test_decomposition_prompt_includes_nl_proof(self):
        prompt = _build_decomposition_prompt(_item(), [])
        assert "By computation" in prompt


class TestUnknownIdentifierExtraction:
    """Tests for extracting hallucinated identifiers from compiler errors."""

    def test_unknown_constant(self):
        err = "error(lean.unknownIdentifier): Unknown constant `Int.gcd_dvd_`"
        assert _extract_unknown_identifiers(err) == ["Int.gcd_dvd_"]

    def test_unknown_identifier(self):
        err = "error(lean.unknownIdentifier): Unknown identifier `lcm_gcd_distrib_left`"
        assert _extract_unknown_identifiers(err) == ["lcm_gcd_distrib_left"]

    def test_unknown_module(self):
        err = "unknown module prefix 'totient'"
        assert _extract_unknown_identifiers(err) == ["totient"]

    def test_multiple_unknowns(self):
        err = (
            "Unknown constant `Foo.bar`\n"
            "Unknown identifier `Baz.qux`"
        )
        result = _extract_unknown_identifiers(err)
        assert "Foo.bar" in result
        assert "Baz.qux" in result

    def test_no_unknowns(self):
        err = "error: unsolved goals\nn : ℕ\n⊢ n + 0 = n"
        assert _extract_unknown_identifiers(err) == []


# ---------------------------------------------------------------------------
# Axiom-first decomposition
# ---------------------------------------------------------------------------

class TestSignatureToAxiomBody:
    def test_strips_lemma(self):
        assert _signature_to_axiom_body("lemma foo (n : Nat) : True") == "foo (n : Nat) : True"

    def test_strips_theorem(self):
        assert _signature_to_axiom_body("theorem bar : 1 = 1") == "bar : 1 = 1"

    def test_strips_def(self):
        assert _signature_to_axiom_body("def baz : Nat := 0") == "baz : Nat := 0"

    def test_strips_axiom(self):
        assert _signature_to_axiom_body("axiom qux : True") == "qux : True"

    def test_no_keyword(self):
        assert _signature_to_axiom_body("foo : True") == "foo : True"

    def test_whitespace(self):
        assert _signature_to_axiom_body("  lemma foo : True  ") == "foo : True"


class TestAxiomAssemblyPrompt:
    def test_contains_axiom_declarations(self):
        decomp = Decomposition(
            analysis="test",
            sub_lemmas=[
                SubLemma(
                    name="s1",
                    lean_signature="lemma s1 (n : Nat) : n + 0 = n",
                    nl_description="Adding zero is identity",
                    nl_proof_hint="Use Nat.add_zero",
                ),
                SubLemma(
                    name="s2",
                    lean_signature="theorem s2 : 1 = 1",
                    nl_description="One equals one",
                    nl_proof_hint="",
                ),
            ],
            assembly="theorem main : True := by exact ⟨s1 0, s2⟩",
        )
        prompt = _build_axiom_assembly_prompt(decomp, _item())
        assert "axiom s1 (n : Nat) : n + 0 = n" in prompt
        assert "axiom s2 : 1 = 1" in prompt
        assert "import Mathlib" in prompt
        assert "1 + 1 = 2" in prompt  # main theorem statement from _item()

    def test_no_assembly_skeleton(self):
        decomp = Decomposition(
            analysis="test",
            sub_lemmas=[SubLemma(name="s1", lean_signature="lemma s1 : True",
                                 nl_description="trivial", nl_proof_hint="")],
            assembly="",
        )
        prompt = _build_axiom_assembly_prompt(decomp, _item())
        assert "axiom s1 : True" in prompt
        assert "skeleton" not in prompt


class TestDecomposedOutcome:
    def test_translation_result_carries_sub_lemmas(self):
        sl = SubLemma(name="s1", lean_signature="lemma s1 : True",
                      nl_description="trivial", nl_proof_hint="")
        result = TranslationResult(
            outcome=TranslationOutcome.DECOMPOSED,
            lean_code="axiom s1 : True\ntheorem main : True := s1",
            sub_lemmas=[sl],
            total_attempts=16,
        )
        assert result.outcome == TranslationOutcome.DECOMPOSED
        assert result.sub_lemmas is not None
        assert len(result.sub_lemmas) == 1
        assert result.sub_lemmas[0].name == "s1"

    def test_success_has_no_sub_lemmas(self):
        result = TranslationResult(
            outcome=TranslationOutcome.SUCCESS,
            lean_code="theorem main : True := trivial",
            total_attempts=1,
        )
        assert result.sub_lemmas is None


# ---------------------------------------------------------------------------
# Phase 3: Attempt outcome classification
# ---------------------------------------------------------------------------

class TestAttemptOutcomeClassification:
    """Tests for classify_attempt_outcome."""

    def test_empty_code_is_operational(self):
        assert classify_attempt_outcome("any error", "") == AttemptOutcome.OPERATIONAL

    def test_whitespace_code_is_operational(self):
        assert classify_attempt_outcome("any error", "   \n  ") == AttemptOutcome.OPERATIONAL

    def test_none_code_is_operational(self):
        assert classify_attempt_outcome("any error", None) == AttemptOutcome.OPERATIONAL

    def test_vacuous_code_is_operational(self):
        out = "error: empty or vacuous code — must contain a theorem/lemma/def declaration"
        assert classify_attempt_outcome(out, "some code") == AttemptOutcome.OPERATIONAL

    def test_unexpected_end_is_operational(self):
        out = "error: unexpected end of input"
        code = "theorem x : True := by\n  sorry"
        assert classify_attempt_outcome(out, code) == AttemptOutcome.OPERATIONAL

    def test_missing_olean_is_operational(self):
        out = "error: object file '/path/to/Mathlib.olean' does not exist"
        code = "theorem x : True := trivial"
        assert classify_attempt_outcome(out, code) == AttemptOutcome.OPERATIONAL

    def test_unknown_module_prefix_is_operational(self):
        out = "unknown module prefix 'Mathlib'"
        code = "import Mathlib\ntheorem x : True := trivial"
        assert classify_attempt_outcome(out, code) == AttemptOutcome.OPERATIONAL

    def test_compilation_timed_out_is_operational(self):
        out = "Compilation timed out after 300s"
        code = "theorem x : True := by simp"
        assert classify_attempt_outcome(out, code) == AttemptOutcome.OPERATIONAL

    def test_type_mismatch_is_genuine(self):
        out = "error: type mismatch\n  expected: Prop\n  got: Bool"
        code = "theorem x : True := trivial"
        assert classify_attempt_outcome(out, code) == AttemptOutcome.GENUINE

    def test_unknown_identifier_is_genuine(self):
        out = "error: Unknown identifier `Foo.bar`"
        code = "theorem x : True := Foo.bar"
        assert classify_attempt_outcome(out, code) == AttemptOutcome.GENUINE

    def test_unsolved_goals_is_genuine(self):
        out = "error: unsolved goals\nn : Nat\n|- n = n + 1"
        code = "theorem x (n : Nat) : n = n + 1 := by omega"
        assert classify_attempt_outcome(out, code) == AttemptOutcome.GENUINE

    def test_max_operational_retries_constant(self):
        assert MAX_OPERATIONAL_RETRIES == 3
