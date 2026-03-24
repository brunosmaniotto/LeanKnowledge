import Mathlib

open Finset BigOperators
open Topology
open BigOperators

noncomputable def expenditure_dot {n : ℕ} (p x : Fin n → ℝ) : ℝ :=
  ∑ i, p i * x i

/-- Under Assumption 1.2, Marshallian and Hicksian demands are related by:
    (1) x(p,y) = xh(p, v(p,y)), and (2) xh(p,u) = x(p, e(p,u)). -/
theorem Theorem_1_9
    {n : ℕ}
    (u_func : (Fin n → ℝ) → ℝ)
    (x xh : (Fin n → ℝ) → ℝ → Fin n → ℝ)
    (v e : (Fin n → ℝ) → ℝ → ℝ)
    (p : Fin n → ℝ) (y u₀ : ℝ)
    -- Optimality conditions
    (hv_def : u_func (x p y) = v p y)
    (hbudget : expenditure_dot p (x p y) = y)
    (hutil : u_func (xh p u₀) = u₀)
    (he_def : expenditure_dot p (xh p u₀) = e p u₀)
    -- Duality (Theorem 1.8)
    (he_v : e p (v p y) = y)
    (hv_e : v p (e p u₀) = u₀)
    -- Uniqueness of Hicksian demand
    (h_xh_unique : ∀ z, u_func z ≥ v p y →
      expenditure_dot p z = e p (v p y) → z = xh p (v p y))
    -- Uniqueness of Marshallian demand
    (h_x_unique : ∀ z, expenditure_dot p z ≤ e p u₀ →
      u_func z = v p (e p u₀) → z = x p (e p u₀)) :
    x p y = xh p (v p y) ∧ xh p u₀ = x p (e p u₀) := by
  constructor
  · -- Part (1): x(p,y) solves EMP at u = v(p,y) with cost e(p,v(p,y)) = y
    apply h_xh_unique
    · linarith
    · linarith
  · -- Part (2): xh(p,u₀) solves UMP at y = e(p,u₀) with utility v(p,e(p,u₀)) = u₀
    apply h_x_unique
    · linarith
    · linarith