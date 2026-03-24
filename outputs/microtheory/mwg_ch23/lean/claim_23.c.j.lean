import Mathlib

open MeasureTheory Set
open Topology

theorem envelope_transfer_formula
    {θL θH : ℝ} (hLH : θL ≤ θH)
    {k : ℝ → ℝ} {ti : ℝ → ℝ} {dvdk : ℝ → ℝ}
    (hk_diff : Differentiable ℝ k)
    (hti_diff : Differentiable ℝ ti)
    (hFOC : ∀ θ ∈ Icc θL θH,
      dvdk θ * deriv k θ + deriv ti θ = 0)
    (hcont : Continuous (fun s => dvdk s * deriv k s))
    {θ : ℝ} (hθ : θ ∈ Icc θL θH) :
    ti θ = ti θL - ∫ s in θL..θ, dvdk s * deriv k s := by
  have hderiv_eq : ∀ s ∈ Set.uIcc θL θ, HasDerivAt ti (-(dvdk s * deriv k s)) s := by
    intro s hs
    have hd := (hti_diff s).hasDerivAt
    have hs_Icc : s ∈ Icc θL θH := by
      rw [Set.uIcc_of_le hθ.1] at hs
      exact ⟨hs.1, le_trans hs.2 hθ.2⟩
    have hfoc := hFOC s hs_Icc
    have heq : deriv ti s = -(dvdk s * deriv k s) := by linarith
    rwa [heq] at hd
  have key : ∫ s in θL..θ, -(dvdk s * deriv k s) = ti θ - ti θL :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt
      (fun s hs => hderiv_eq s hs)
      (hcont.neg.intervalIntegrable _ _)
  have : ∫ s in θL..θ, dvdk s * deriv k s = -(ti θ - ti θL) := by
    rw [← key]
    simp [intervalIntegral.integral_neg]
  linarith