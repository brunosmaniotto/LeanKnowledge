import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Theorem_M_B_2
    {N : ℕ} {r : ℤ} (f : (Fin N → ℝ) → ℝ)
    (hf_diff : Differentiable ℝ f)
    (hf_hom : ∀ (t : ℝ) (x : Fin N → ℝ), f (t • x) = t ^ r * f x)
    (x : Fin N → ℝ) :
    ∑ n : Fin N, fderiv ℝ f x (Pi.single n 1) * x n = (r : ℝ) * f x := by
  have hsmul_deriv : HasDerivAt (fun t : ℝ => t • x) x (1 : ℝ) := by
    have := (hasDerivAt_id (1 : ℝ)).smul_const x
    simpa [one_smul] using this
  have hfx : HasFDerivAt f (fderiv ℝ f x) x :=
    (hf_diff x).hasFDerivAt
  have hchain : HasDerivAt (fun t => f (t • x)) ((fderiv ℝ f x) x) (1 : ℝ) := by
    have h2 : HasFDerivAt f (fderiv ℝ f x) ((fun t : ℝ => t • x) (1 : ℝ)) := by
      simp [one_smul]; exact hfx
    exact h2.comp_hasDerivAt (1 : ℝ) hsmul_deriv
  have hpow : HasDerivAt (fun t : ℝ => t ^ r * f x) ((r : ℝ) * f x) (1 : ℝ) := by
    have h := (hasDerivAt_zpow r (1 : ℝ) (Or.inl one_ne_zero)).mul_const (f x)
    simp [one_zpow, mul_one] at h
    exact h
  have deriv_eq : (fderiv ℝ f x) x = (r : ℝ) * f x := by
    have heq : (fun t => f (t • x)) = fun t => t ^ r * f x := funext (fun t => hf_hom t x)
    rw [heq] at hchain
    exact hchain.unique hpow
  have sum_eq : ∑ n : Fin N, fderiv ℝ f x (Pi.single n 1) * x n = (fderiv ℝ f x) x := by
    have key : x = ∑ n : Fin N, x n • (Pi.single n (1 : ℝ) : Fin N → ℝ) := by
      ext i
      simp [Finset.sum_apply, Pi.smul_apply, Pi.single_apply, smul_eq_mul]
    calc ∑ n : Fin N, fderiv ℝ f x (Pi.single n 1) * x n
        = ∑ n : Fin N, x n * fderiv ℝ f x ((Pi.single n (1 : ℝ) : Fin N → ℝ)) := by
          congr 1; ext n; ring
      _ = ∑ n : Fin N, fderiv ℝ f x (x n • (Pi.single n (1 : ℝ) : Fin N → ℝ)) := by
          congr 1; ext n; rw [map_smul, smul_eq_mul]
      _ = fderiv ℝ f x (∑ n : Fin N, x n • (Pi.single n (1 : ℝ) : Fin N → ℝ)) := by
          rw [map_sum]
      _ = (fderiv ℝ f x) x := by
          rw [← key]
  rw [sum_eq, deriv_eq]