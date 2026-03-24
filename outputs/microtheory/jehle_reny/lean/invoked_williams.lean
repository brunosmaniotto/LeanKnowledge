import Mathlib
set_option linter.unusedVariables false

theorem Invoked_Williams (N : ℕ) (T : Type)
    (VCG_cost : Fin N → (Fin N → T) → ℝ)
    (VCG_utility : Fin N → (Fin N → T) → ℝ)
    (outside_option : Fin N → ℝ)
    (Claim_9_5_4_c : ∀ (i : Fin N) (t : Fin N → T), 0 ≤ VCG_cost i t)
    (Claim_9_5_4_d : ∀ (i : Fin N) (t : Fin N → T), VCG_utility i t ≥ outside_option i)
    (t : Fin N → T) :
    (∀ i, 0 ≤ VCG_cost i t) ∧ (∀ i, VCG_utility i t ≥ outside_option i) := by
  exact ⟨fun i => Claim_9_5_4_c i t, fun i => Claim_9_5_4_d i t⟩