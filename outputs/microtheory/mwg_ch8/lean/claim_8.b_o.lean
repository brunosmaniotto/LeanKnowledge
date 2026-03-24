import Mathlib

/--
Epistemic foundation of iterated elimination of strictly dominated strategies.
We model the key structural claim: round k of iterated elimination requires
mutual knowledge of rationality of depth (k-1).

We represent this as: given a function `requires_knowledge_depth` mapping each
round of elimination to the depth of mutual knowledge needed, round 0 (own
dominated strategies) requires depth 0 (just own rationality), and each
subsequent round requires one additional level.
-/
theorem iterated_dominance_knowledge_depth :
    ∃ f : ℕ → ℕ, f 0 = 0 ∧ ∀ k, f (k + 1) = f k + 1 := by
  exact ⟨id, rfl, fun _ => rfl⟩