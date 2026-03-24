import Mathlib

open Filter Topology
open BigOperators
open Topology

noncomputable section

-- Number of firms
variable {J : Type*} [Fintype J] [Nonempty J] [DecidableEq J]

-- Profit function: pi q k is the profit of firm k given output vector q
variable (pi : (J → ℝ) → (J → ℝ))

-- q_bar is the joint profit-maximizing output vector
variable (q_bar : J → ℝ)

-- Definition of partial derivative of firm k's profit with respect to its own output
noncomputable def marginal_profit_firm_k (k : J) (q : J → ℝ) : ℝ :=
  deriv (fun t => (pi (Function.update q k t)) k) (q k)

-- Definition of Nash Equilibrium
def NashEquilibrium (profit_fn : (J → ℝ) → (J → ℝ)) (q : J → ℝ) : Prop :=
  ∀ k : J, ∀ q_k_prime : ℝ, (profit_fn (Function.update q k q_k_prime)) k ≤ (profit_fn q) k

-- Hypothesis: At q_bar, each firm's marginal profit with respect to its own output is strictly positive.
variable (h_deriv_pos : ∀ k : J, marginal_profit_firm_k pi k q_bar > 0)

-- Hypothesis: Profit function is differentiable for each firm's profit wrt its own output.
variable (h_differentiable : ∀ k : J, DifferentiableAt ℝ (fun t => (pi (Function.update q_bar k t)) k) (q_bar k))