import Mathlib

open Set
open Topology
open Filter
open scoped Topology

variable {φ_i : ℝ → ℝ}
variable {p : ℝ}
variable {x_i_star : ℝ}

-- Assumptions:
-- φ_i is differentiable everywhere.
variable (h_deriv_phi : Differentiable ℝ φ_i)
-- x_i_star is non-negative.
variable (h_x_nonneg : x_i_star ≥ 0)
-- x_i_star maximizes the objective function φ_i(x) - p*x over non-negative x.
variable (h_maximizer : IsMaxOn (fun x => φ_i x - p * x) (Ici 0) x_i_star)

-- Define the objective function for clarity and to avoid notation parsing issues
def objective_f (x : ℝ) : ℝ := φ_i x - p * x