import Mathlib

theorem Condition_11B1
    (φ : ℝ → ℝ) (hstar : ℝ)
    (hstar_nonneg : 0 ≤ hstar)
    (hstar_max : IsLocalMax φ hstar) :
    deriv φ hstar ≤ 0 ∧ (0 < hstar → deriv φ hstar = 0) := by
  have hd := IsLocalMax.deriv_eq_zero hstar_max
  exact ⟨le_of_eq hd, fun _ => hd⟩