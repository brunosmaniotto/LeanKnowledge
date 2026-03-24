import Mathlib

open Filter Topology
open Topology

/-- Euler's theorem for homogeneous functions: if f(t•x) = t^k · f(x) for all t > 0,
    then ∇f(x)·x = k·f(x). -/
theorem Invoked_Theorem_A2_7
    {n : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (x : Fin n → ℝ)
    (k : ℕ)
    (hf_hom : ∀ t : ℝ, 0 < t → f (t • x) = t ^ k * f x)
    : deriv (fun t : ℝ => f (t • x)) 1 = ↑k * f x := by
  have heq : (fun t => f (t • x)) =ᶠ[𝓝 (1 : ℝ)] fun t => t ^ k * f x := by
    filter_upwards [Ioi_mem_nhds zero_lt_one] with t ht
    exact hf_hom t ht
  have h1 : HasDerivAt (fun t : ℝ => t ^ k * f x) (↑k * 1 ^ (k - 1) * f x) 1 :=
    (hasDerivAt_pow k (1 : ℝ)).mul_const (f x)
  simp only [one_pow, mul_one] at h1
  rw [Filter.EventuallyEq.deriv_eq heq, h1.deriv]