import Mathlib

noncomputable def sellContract (α : ℝ) (π : ℝ) : ℝ := π - α

/-- The manager receives full marginal returns and the principal bears zero risk
    under the "sell the project" contract w(π) = π - α. -/
theorem Claim_14B_f (α : ℝ) :
    (∀ π dπ : ℝ, sellContract α (π + dπ) - sellContract α π = dπ) ∧
    (∀ π : ℝ, π - sellContract α π = α) := by
  constructor
  · intro π dπ; unfold sellContract; ring
  · intro π; unfold sellContract; ring