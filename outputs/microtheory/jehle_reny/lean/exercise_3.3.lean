import Mathlib

open Matrix Finset BigOperators
open Topology
open BigOperators

/-- Euler's theorem: when f is homogeneous of degree one,
    f(x) = Σ_i MP_i(x) · x_i (output decomposes into marginal factor payments). -/
theorem exercise_3_3
    {n : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (x : Fin n → ℝ)
    (MP : Fin n → ℝ)                          -- marginal products ∂f/∂x_i at x
    (hHom : ∀ t : ℝ, f (t • x) = t * f x)    -- degree-1 homogeneity
    -- Euler's identity: differentiating hHom at t = 1 yields ∇f(x) · x = f(x)
    (hEuler : MP ⬝ᵥ x = f x)
    : f x = ∑ i : Fin n, MP i * x i := by
  rw [← hEuler]
  simp [dotProduct]