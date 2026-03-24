import Mathlib

open Set Real

noncomputable section

theorem Claim_5D_a
    (p : ℝ) (C : ℝ → ℝ) (q : ℝ)
    (hq_pos : q > 0)
    (hC_diff : DifferentiableAt ℝ C q)
    (h_max : ∀ q' : ℝ, q' ≥ 0 → p * q - C q ≥ p * q' - C q') :
    deriv C q = p := by
  set profit := fun x => p * x - C x with hprofit_def
  have hprofit_diff : DifferentiableAt ℝ profit q := by
    exact (differentiableAt_const p |>.mul differentiableAt_id).sub hC_diff
  have hprofit_deriv : deriv profit q = p - deriv C q := by
    have h1 : HasDerivAt (fun x => p * x) p q := by
      have := (hasDerivAt_id q).const_mul p
      simp [mul_comm] at this
      exact this
    have h2 : HasDerivAt C (deriv C q) q := hC_diff.hasDerivAt
    have h3 : HasDerivAt profit (p - deriv C q) q := h1.sub h2
    exact h3.deriv
  have h_local_max : IsLocalMax profit q := by
    apply IsMaxOn.isLocalMax _ (Ici_mem_nhds hq_pos)
    intro x hx
    exact h_max x (mem_Ici.mp hx)
  have h_zero : deriv profit q = 0 := IsLocalMax.hasDerivAt_eq_zero h_local_max hprofit_diff.hasDerivAt
  linarith