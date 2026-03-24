import Mathlib

open BigOperators
open Topology
open Finset

-- Define the types for firms (J) and externalities (I)
variable {J I : Type} [Fintype J] [Fintype I]

-- Profit function for each firm j, taking externality h_j as input
variable (π : J → ℝ → ℝ)
-- Externality cost function for each externality i, taking total externality h_total as input
variable (φ : I → ℝ → ℝ)
-- Initial permits for each firm j
variable (h_0 : J → ℝ)

-- Let h_j_demand be the demand of firm j for permits
variable (h_j_demand : J → ℝ)

-- Define the total permits distributed, h°
def h_total_given : ℝ := Finset.sum Finset.univ h_0

-- The equilibrium price of permits, p_h#
variable (p_h_sharp : ℝ)

-- Assumptions for the theorem

-- Differentiability assumptions for the profit and externality cost functions
variable (h_deriv_π : ∀ j, DifferentiableAt ℝ (π j) (h_j_demand j))
variable (h_deriv_φ : ∀ i, DifferentiableAt ℝ (φ i) (h_total_given h_0))

-- Non-negativity of demand
variable (h_j_nonneg : ∀ j, h_j_demand j ≥ 0)
-- Positivity of demand, which simplifies the FOC to equality (as implied by the problem statement for optimal allocation)
variable (h_j_pos : ∀ j, h_j_demand j > 0)

-- First Order Condition (FOC) for firm j's profit maximization.
-- Given h_j_pos, the FOC "π_j'(h_j) ≤ p_h# with equality if h_j > 0" simplifies to π_j'(h_j) = p_h#
variable (h_foc : ∀ j, deriv (π j) (h_j_demand j) = p_h_sharp)

-- Market clearing condition (used to establish h_total_given)
variable (h_market_clearing : Finset.sum Finset.univ h_j_demand = h_total_given h_0)

-- Equilibrium price definition, p_h# = −Σ_i φ_i'(h°)
variable (h_eq_price_def : p_h_sharp = -Finset.sum Finset.univ (fun i => deriv (φ i) (h_total_given h_0)))

-- The claim "each firm using h_j° permits" means h_j_demand j = h_0 j at equilibrium
variable (h_allocation_is_initial : ∀ j, h_j_demand j = h_0 j)