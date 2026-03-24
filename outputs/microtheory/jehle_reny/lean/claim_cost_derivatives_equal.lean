import Mathlib
open Set
open Real
open Topology
set_option linter.unusedVariables false

theorem Claim_cost_derivatives_equal
    (i : ℕ) (cA cB : ℕ → ℝ → ℝ)
    (hA_diff : ∀ t ∈ Ioo (0 : ℝ) 1, DifferentiableAt ℝ (cA i) t)
    (hB_diff : ∀ t ∈ Ioo (0 : ℝ) 1, DifferentiableAt ℝ (cB i) t)
    (heq_deriv : ∀ t ∈ Ioo (0 : ℝ) 1, deriv (cA i) t = deriv (cB i) t)
    (hA_cont : ContinuousOn (cA i) (Icc (0 : ℝ) 1))
    (hB_cont : ContinuousOn (cB i) (Icc (0 : ℝ) 1)) :
    ∀ t ∈ Icc (0 : ℝ) 1, cA i t - cA i 0 = cB i t - cB i 0 := by
  set h := cA i - cB i with h_def
  have h_cont : ContinuousOn h (Icc (0 : ℝ) 1) :=
    ContinuousOn.sub hA_cont hB_cont
  have h_diff : ∀ t ∈ Ioo (0 : ℝ) 1, DifferentiableAt ℝ h t := by
    intro t ht
    exact (hA_diff t ht).sub (hB_diff t ht)
  have h_deriv_zero : ∀ t ∈ Ioo (0 : ℝ) 1, deriv h t = 0 := by
    intro t ht
    have hA' : DifferentiableAt ℝ (cA i) t := hA_diff t ht
    have hB' : DifferentiableAt ℝ (cB i) t := hB_diff t ht
    rw [deriv_sub hA' hB', heq_deriv t ht, sub_self]
  intro t ht
  rcases eq_or_lt_of_le ht.1 with (rfl | h0)
  · simp
  · have h_cont' : ContinuousOn h (Icc (0 : ℝ) t) :=
      h_cont.mono (Icc_subset_Icc_right ht.2)
    have h_diff' : DifferentiableOn ℝ h (Ioo (0 : ℝ) t) := by
      intro x hx
      have hx1 : x ∈ Ioo (0 : ℝ) 1 := ⟨hx.1, lt_of_lt_of_le hx.2 ht.2⟩
      exact (h_diff x hx1).differentiableWithinAt
    have hMVT : ∃ x ∈ Ioo (0 : ℝ) t, deriv h x = (h t - h 0) / (t - 0) :=
      exists_deriv_eq_slope h (by linarith) h_cont' h_diff'
    rcases hMVT with ⟨x, hx, hx'⟩
    have hx1 : x ∈ Ioo (0 : ℝ) 1 := ⟨hx.1, lt_of_lt_of_le hx.2 ht.2⟩
    have deriv_zero : deriv h x = 0 := h_deriv_zero x hx1
    rw [deriv_zero, sub_zero] at hx'
    have : (h t - h 0) / t = 0 := by linarith
    rcases div_eq_zero_iff.1 this with (H | H)
    · have H' : h t = h 0 := by linarith
      simp_rw [h_def, Pi.sub_apply] at H' ⊢
      linarith
    · linarith