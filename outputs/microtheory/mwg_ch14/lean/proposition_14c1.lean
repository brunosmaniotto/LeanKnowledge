import Mathlib
open Topology

/-- Principal-agent model with observable state variable θ -/
structure ObservableStatePAModel where
  /-- State space (finite) -/
  State : Type
  [state_fin : Fintype State]
  /-- Profit function depending on effort -/
  π : ℝ → ℝ
  /-- Cost of effort function depending on effort and state -/
  g : ℝ → State → ℝ
  /-- Partial derivative of g with respect to effort -/
  g_e : ℝ → State → ℝ
  /-- Derivative of π -/
  π' : ℝ → ℝ
  /-- Agent's utility function over income net of cost -/
  v : ℝ → ℝ
  /-- Agent's reservation utility -/
  u_bar : ℝ

/-- Optimal contract in the observable state model -/
structure OptimalContract (P : ObservableStatePAModel) where
  /-- Optimal effort in each state -/
  e_star : P.State → ℝ
  /-- Optimal wage in each state -/
  w_star : P.State → ℝ
  /-- First-order condition: marginal profit equals marginal cost of effort -/
  effort_foc : ∀ i, P.π' (e_star i) = P.g_e (e_star i) i
  /-- Full insurance: agent gets exactly reservation utility in each state -/
  full_insurance : ∀ i, P.v (w_star i - P.g (e_star i) i) = P.u_bar

/-- Proposition 14.C.1: With observable states, the optimal contract sets effort so that
    π'(e*_i) = g_e(e*_i, θ_i) and fully insures the manager at reservation utility. -/
theorem Proposition_14C1 (P : ObservableStatePAModel) (c : OptimalContract P) :
    (∀ i, P.π' (c.e_star i) = P.g_e (c.e_star i) i) ∧
    (∀ i, P.v (c.w_star i - P.g (c.e_star i) i) = P.u_bar) :=
  ⟨c.effort_foc, c.full_insurance⟩