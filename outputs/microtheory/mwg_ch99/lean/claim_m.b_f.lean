import Mathlib

open Finset BigOperators
open Topology

theorem Claim_M_B_f
    {N : ℕ} (f : (Fin N → ℝ) → ℝ)
    (hf_diff : Differentiable ℝ f)
    (hf_hom : ∀ (t : ℝ) (x : Fin N → ℝ), 0 < t → f (t • x) = f x)
    (x : Fin N → ℝ) :
    (fderiv ℝ f x) x = 0 := by
  have const_deriv : HasDerivAt (fun t : ℝ => f (t • x)) 0 1 := by
    have hconst : HasDerivAt (fun _ : ℝ => f x) 0 1 := hasDerivAt_const 1 (f x)
    apply hconst.congr_of_eventuallyEq
    filter_upwards [Ioi_mem_nhds one_pos] with t ht
    exact hf_hom t x ht
  have chain_deriv : HasDerivAt (fun t : ℝ => f (t • x)) ((fderiv ℝ f x) x) 1 := by
    have smul_deriv : HasDerivAt (fun t : ℝ => t • x) x 1 := by
      simpa using (hasDerivAt_id (1 : ℝ)).smul_const x
    have := (hf_diff.differentiableAt.hasFDerivAt).comp_hasDerivAt 1 smul_deriv
    simp at this
    exact this
  exact (const_deriv.unique chain_deriv).symm