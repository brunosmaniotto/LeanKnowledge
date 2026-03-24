import Mathlib

open BigOperators Finset
open Topology

/-- The Lagrangian for a constrained optimization problem max f(x) s.t. gₘ(x) = bₘ.
    L(x, lam) = f(x) − Σₘ lamₘ[gₘ(x) − bₘ] -/
noncomputable def MWG.Lagrangian
    {n m : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (g : Fin m → (Fin n → ℝ) → ℝ)
    (b : Fin m → ℝ)
    (x : Fin n → ℝ)
    (lam : Fin m → ℝ) : ℝ :=
  f x - ∑ j ∈ univ, lam j * (g j x - b j)

/-- First-order conditions for the Lagrangian (M.K.2):
    Stationarity w.r.t. x and the equality constraints gₘ(x) = bₘ. -/
structure MWG.LagrangianFOC
    {n m : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (g : Fin m → (Fin n → ℝ) → ℝ)
    (b : Fin m → ℝ)
    (x : Fin n → ℝ)
    (lam : Fin m → ℝ) : Prop where
  /-- FOC w.r.t. x: ∂L/∂xₖ = 0 for each coordinate k -/
  stationarity : ∀ k : Fin n,
    deriv (fun t => MWG.Lagrangian f g b (Function.update x k t) lam) (x k) = 0
  /-- FOC w.r.t. λ: the equality constraints gₘ(x) = bₘ -/
  constraints : ∀ j : Fin m, g j x = b j