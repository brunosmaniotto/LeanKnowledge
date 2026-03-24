import Mathlib

open scoped BigOperators
open Finset
open BigOperators

-- Let I be the set of consumers and J be the set of firms.
-- We assume these are finite types for the summation.
variables {I J : Type} [Fintype I] [Fintype J]
variables {i : I} {j k : J}

-- Define the functions for consumers' utility (φ_i) and firms' profit/cost (π_j).
variables (φ : I → ℝ → ℝ) (π : J → ℝ → ℝ)

-- `h_star` represents the Pareto optimal externality levels (h_1°,...,h_J°).
variables (h_star : J → ℝ)

-- Assume `h_star j` are non-negative. This is a constraint in the maximization problem.
variable (h_star_nonneg : ∀ j, 0 ≤ h_star j)

-- Differentiability assumptions for `φ_i` and `π_j` at the relevant points.
-- `φ i` must be differentiable at the total externality level.
variable (hφ_diff : ∀ i, DifferentiableAt ℝ (φ i) (∑ j', h_star j'))
-- `π j` must be differentiable at its own externality level `h_star j`.
variable (hπ_diff : ∀ j, DifferentiableAt ℝ (π j) (h_star j))

-- The total externality level, which is the sum of all individual externality levels.
def H_total (h_val : J → ℝ) : ℝ := ∑ j, h_val j

-- The objective function to be maximized: Σ_i φ_i(Σ_j h_j) + Σ_j π_j(h_j).