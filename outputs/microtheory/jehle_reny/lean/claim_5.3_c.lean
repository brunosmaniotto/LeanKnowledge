import Mathlib
open BigOperators

/-- Under compactness of Y, the profit function p · y attains a maximum on Y
    by the Weierstrass extreme value theorem. -/
theorem Claim_5_3_c {L : ℕ} (Y : Set (Fin L → ℝ)) (p : Fin L → ℝ)
    (hY_compact : IsCompact Y) (hY_nonempty : Y.Nonempty) :
    ∃ y_star ∈ Y, ∀ y ∈ Y, ∑ l, p l * y l ≤ ∑ l, p l * y_star l := by
  have hcont : Continuous (fun y : Fin L → ℝ => ∑ l, p l * y l) :=
    continuous_finset_sum _ fun l _ => continuous_const.mul (continuous_apply l)
  obtain ⟨x, hxY, hmax⟩ := hY_compact.exists_isMaxOn hY_nonempty hcont.continuousOn
  exact ⟨x, hxY, fun y hy => hmax hy⟩