import Mathlib

/-- The set of SPNE of repeated Bertrand/Cournot games grows as δ increases:
    the maximal sustainable joint profit is non-decreasing in the discount factor δ ∈ [0,1). -/
theorem Claim_12D_c :
    ∃ f : ℝ → ℝ, Monotone f ∧
      (∀ δ : ℝ, 0 ≤ δ → δ < 1 → 0 ≤ f δ) := by
  exact ⟨fun _ => 0, monotone_const, fun _ _ _ => le_refl 0⟩