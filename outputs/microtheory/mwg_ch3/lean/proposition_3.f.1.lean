import Mathlib

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

theorem Proposition_3F1
    (mu : E → ℝ) (K : Set E) (p0 x0 : E)
    (hx0 : x0 ∈ K)
    (hmu_le : ∀ p, mu p ≤ (innerSL ℝ x0) p)
    (hachieve : mu p0 = (innerSL ℝ x0) p0)
    {mu' : E →L[ℝ] ℝ}
    (hmu_diff : HasFDerivAt mu mu' p0) :
    mu' = innerSL ℝ x0 := by
  have hξ_nonneg : ∀ p, 0 ≤ (innerSL ℝ x0) p - mu p := fun p => sub_nonneg.mpr (hmu_le p)
  have hξ_zero : (innerSL ℝ x0) p0 - mu p0 = 0 := sub_eq_zero.mpr hachieve.symm
  have hmin : IsLocalMin (fun p => (innerSL ℝ x0) p - mu p) p0 := by
    apply Filter.Eventually.mono (Filter.univ_mem)
    intro p _
    show (fun p => (innerSL ℝ x0) p - mu p) p0 ≤ (fun p => (innerSL ℝ x0) p - mu p) p
    simp only []
    linarith [hξ_nonneg p, hξ_zero]
  have hξ_deriv : HasFDerivAt (fun p => (innerSL ℝ x0) p - mu p) ((innerSL ℝ x0) - mu') p0 :=
    ((innerSL ℝ x0).hasFDerivAt).sub hmu_diff
  have h0 : (innerSL ℝ x0) - mu' = 0 := hmin.hasFDerivAt_eq_zero hξ_deriv
  exact eq_of_sub_eq_zero h0 |>.symm