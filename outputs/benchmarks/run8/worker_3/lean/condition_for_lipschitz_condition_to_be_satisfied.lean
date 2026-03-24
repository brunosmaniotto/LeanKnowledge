import Mathlib

open Set
open Real

theorem lipschitz_of_bounded_derivative (φ : ℝ → ℝ) (a b : ℝ) (hab : a ≤ b)
    (hderiv : ∀ x ∈ Icc a b, DifferentiableAt ℝ φ x)
    (hbound : ∃ A : ℝ, ∀ y ∈ Icc a b, |deriv φ y| ≤ A) :
    ∃ K : ℝ, ∀ x ∈ Icc a b, ∀ y ∈ Icc a b, |φ x - φ y| ≤ K * |x - y| := by
  rcases hbound with ⟨A, hA⟩
  have ha : a ∈ Icc a b := ⟨le_refl a, hab⟩
  have hpos : 0 ≤ |deriv φ a| := abs_nonneg _
  have h_bound_a : |deriv φ a| ≤ A := hA a ha
  have A_nonneg : 0 ≤ A := by linarith
  use A
  intro x hx y hy
  by_cases hxy : x ≤ y
  · by_cases hlt : x < y
    · have hsub : Icc x y ⊆ Icc a b := by
        intro z hz
        exact ⟨le_trans hx.1 hz.1, le_trans hz.2 hy.2⟩
      have hcont : ContinuousOn φ (Icc x y) := by
        intro z hz
        exact (hderiv z (hsub hz)).continuousAt.continuousWithinAt
      have hdiff : ∀ z ∈ Ioo x y, DifferentiableAt ℝ φ z := fun z hz =>
        hderiv z (hsub ⟨le_of_lt hz.1, le_of_lt hz.2⟩)
      have hdiff_on : DifferentiableOn ℝ φ (Ioo x y) := by
        intro z hz
        exact (hdiff z hz).differentiableWithinAt
      rcases exists_deriv_eq_slope φ hlt hcont hdiff_on with ⟨c, hc, hc'⟩
      have hc_bound : |deriv φ c| ≤ A := hA c (hsub ⟨hc.1.le, hc.2.le⟩)
      have H : φ y - φ x = deriv φ c * (y - x) := by
        field_simp [ne_of_gt (sub_pos_of_lt hlt)] at hc'
        linarith
      calc
        |φ x - φ y| = |φ y - φ x| := abs_sub_comm _ _
        _ = |deriv φ c * (y - x)| := by rw [H]
        _ = |deriv φ c| * |y - x| := abs_mul _ _
        _ = |deriv φ c| * (y - x) := by rw [abs_of_pos (sub_pos_of_lt hlt)]
        _ ≤ A * (y - x) := mul_le_mul_of_nonneg_right hc_bound (sub_pos_of_lt hlt).le
        _ = A * |y - x| := by rw [abs_of_pos (sub_pos_of_lt hlt)]
        _ = A * |x - y| := by rw [abs_sub_comm]

    · have h : x = y := by linarith
      simp [h]
  · have hlt : y < x := by linarith
    have hsub : Icc y x ⊆ Icc a b := by
      intro z hz
      exact ⟨le_trans hy.1 hz.1, le_trans hz.2 hx.2⟩
    have hcont : ContinuousOn φ (Icc y x) := by
      intro z hz
      exact (hderiv z (hsub hz)).continuousAt.continuousWithinAt
    have hdiff : ∀ z ∈ Ioo y x, DifferentiableAt ℝ φ z := fun z hz =>
      hderiv z (hsub ⟨le_of_lt hz.1, le_of_lt hz.2⟩)
    have hdiff_on : DifferentiableOn ℝ φ (Ioo y x) := by
      intro z hz
      exact (hdiff z hz).differentiableWithinAt
    rcases exists_deriv_eq_slope φ hlt hcont hdiff_on with ⟨c, hc, hc'⟩
    have hc_bound : |deriv φ c| ≤ A := hA c (hsub ⟨hc.1.le, hc.2.le⟩)
    have H : φ x - φ y = deriv φ c * (x - y) := by
      field_simp [ne_of_gt (sub_pos_of_lt hlt)] at hc'
      linarith
    calc
      |φ x - φ y| = |deriv φ c * (x - y)| := by rw [H]
      _ = |deriv φ c| * |x - y| := abs_mul _ _
      _ = |deriv φ c| * (x - y) := by rw [abs_of_pos (sub_pos_of_lt hlt)]
      _ ≤ A * (x - y) := mul_le_mul_of_nonneg_right hc_bound (sub_pos_of_lt hlt).le
      _ = A * |x - y| := by rw [abs_of_pos (sub_pos_of_lt hlt)]