import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem euler_homogeneous_degree_one
    {N : ℕ}
    (f : (Fin N → ℝ) → ℝ)
    (x : Fin N → ℝ)
    (hf_diff : DifferentiableAt ℝ f x)
    (hom : ∀ t : ℝ, 0 < t → f (t • x) = t * f x) :
    ∑ n : Fin N, (fderiv ℝ f x) (Pi.single n (x n)) = f x := by
  have hx_decomp : (∑ n : Fin N, Pi.single n (x n)) = x := by
    ext i; simp [Finset.sum_apply, Pi.single_apply]
  rw [← map_sum, hx_decomp]
  have heq_nhd : (fun t : ℝ => f (t • x)) =ᶠ[nhds 1] (fun t => t * f x) := by
    rw [Filter.eventuallyEq_iff_exists_mem]
    exact ⟨Set.Ioi 0, Ioi_mem_nhds one_pos, fun t ht => hom t (Set.mem_Ioi.mp ht)⟩
  have deriv_rhs : deriv (fun t : ℝ => t * f x) 1 = f x := by
    simp [deriv_mul_const, deriv_id']
  have hsmul_deriv : HasDerivAt (fun t : ℝ => t • x) x 1 := by
    have := (hasDerivAt_id (1 : ℝ)).smul_const x
    simpa using this
  have hfx : HasFDerivAt f (fderiv ℝ f x) x := hf_diff.hasFDerivAt
  have h1smul : (1 : ℝ) • x = x := one_smul ℝ x
  have hfx' : HasFDerivAt f (fderiv ℝ f x) ((fun t : ℝ => t • x) 1) := by
    simp [h1smul]; exact hfx
  have hcomp : HasDerivAt (fun t : ℝ => f (t • x)) ((fderiv ℝ f x) x) 1 := by
    have := HasFDerivAt.comp_hasDerivAt 1 hfx' hsmul_deriv
    simp [h1smul] at this
    exact this
  have deriv_lhs : deriv (fun t : ℝ => f (t • x)) 1 = (fderiv ℝ f x) x :=
    hcomp.deriv
  have deriv_eq : deriv (fun t : ℝ => f (t • x)) 1 = deriv (fun t : ℝ => t * f x) 1 :=
    Filter.EventuallyEq.deriv_eq heq_nhd
  linarith