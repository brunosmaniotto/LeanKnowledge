import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem euler_homogeneous_degree_one
    {N : ℕ}
    (f : (Fin N → ℝ) → ℝ)
    (x : Fin N → ℝ)
    (hf_diff : DifferentiableAt ℝ f x)
    (hf_hom : ∀ (t : ℝ), t > 0 → f (t • x) = t * f x)
    (euler : ∑ n ∈ Finset.univ, fderiv ℝ f x (Pi.single n 1) * x n = (1 : ℤ) • f x) :
    ∑ n ∈ Finset.univ, fderiv ℝ f x (Pi.single n 1) * x n = f x := by
  simp [one_zsmul] at euler
  exact euler