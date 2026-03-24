import Mathlib

/-- With only two possible types of consumers, a pure strategy sequential equilibrium
is either separating or pooling. These are the only two possibilities. -/
theorem Claim_8_1_2_j
    {Action : Type*} [DecidableEq Action]
    (ψ_l ψ_h : Action) :
    (ψ_l = ψ_h) ∨ (ψ_l ≠ ψ_h) := by
  exact eq_or_ne ψ_l ψ_h