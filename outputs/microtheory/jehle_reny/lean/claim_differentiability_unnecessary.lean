import Mathlib
open Set
open Real
open Topology
set_option linter.unusedVariables false

theorem Claim_differentiability_unnecessary {f g : ℝ → ℝ}
    (hf : ContinuousOn f (Icc 0 1)) (hg : ContinuousOn g (Icc 0 1))
    (hfd : ∀ x ∈ Ioo 0 1, DifferentiableAt ℝ f x) (hgd : ∀ x ∈ Ioo 0 1, DifferentiableAt ℝ g x)
    (hderiv : ∀ x ∈ Ioo 0 1, deriv f x = deriv g x) : ∃ C, ∀ x ∈ Icc 0 1, f x = g x + C := by
  set h := f - g with h_def
  have h_cont : ContinuousOn h (Icc 0 1) := ContinuousOn.sub hf hg
  have h_diff : ∀ x ∈ Ioo 0 1, DifferentiableAt ℝ h x := by
    intro x hx
    exact DifferentiableAt.sub (hfd x hx) (hgd x hx)
  have h_deriv_zero : ∀ x ∈ Ioo 0 1, deriv h x = 0 := by
    intro x hx
    rw [deriv_sub (hfd x hx) (hgd x hx), hderiv x hx, sub_self]
  refine ⟨f 0 - g 0, fun x hx => ?_⟩
  rcases hx with ⟨hx_left, hx_right⟩
  by_cases hx0 : x = 0
  · rw [hx0]
    ring
  · have h_pos : 0 < x := lt_of_le_of_ne hx_left (Ne.symm hx0)
    have h_cont_on : ContinuousOn h (Icc 0 x) :=
      h_cont.mono (Icc_subset_Icc_right (by linarith))
    have h_diff_on : DifferentiableOn ℝ h (Ioo 0 x) := by
      intro y hy
      have : y ∈ Ioo 0 1 := ⟨hy.left, lt_of_lt_of_le hy.right hx_right⟩
      exact (h_diff y this).differentiableWithinAt
    rcases exists_deriv_eq_slope h (by linarith) h_cont_on h_diff_on with ⟨ξ, hξ, H⟩
    have hξ_mem : ξ ∈ Ioo 0 1 := ⟨hξ.left, hξ.right.trans_le hx_right⟩
    rw [h_deriv_zero ξ hξ_mem] at H
    have : (h x - h 0) / (x - 0) = 0 := by rw [← H]
    field_simp [ne_of_gt h_pos] at this
    dsimp [h] at this ⊢
    linarith