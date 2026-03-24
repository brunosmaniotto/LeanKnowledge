import Mathlib

open BigOperators Finset
open Topology

/-- The Lagrangian for the general constrained optimization problem:
    max f(x) subject to gʲ(x) = 0 for j = 1,...,m.
    L(x, lam) = f(x) - Σⱼ lamⱼ · gʲ(x) -/
noncomputable def Definition_A2_GeneralLagrangian
    {n m : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (g : Fin m → (Fin n → ℝ) → ℝ)
    (x : Fin n → ℝ)
    (lam : Fin m → ℝ) : ℝ :=
  f x - ∑ j : Fin m, lam j * g j x