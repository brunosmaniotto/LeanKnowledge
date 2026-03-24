import Mathlib

open Finset
open BigOperators

-- Define the types for indices I (individuals) and J (externalities)
variable {I J : Type} [Fintype I] [Fintype J] [DecidableEq I] [DecidableEq J]

-- Define the functions φ_i (utility for individual i) and π_j (externality/benefit for individual j)
variable (φ : I → ℝ → ℝ) (π : J → ℝ → ℝ)

-- Define the optimal allocation variables h_i° and h_j°, and the Lagrange multiplier μ
variable (h_i_star : I → ℝ) (h_j_star : J → ℝ) (μ_star : ℝ)

-- Assume differentiability of φ_i and π_j at the optimal points
variable (differentiable_φ : ∀ i, DifferentiableAt ℝ (φ i) (h_i_star i))
variable (differentiable_π : ∀ j, DifferentiableAt ℝ (π j) (h_j_star j))

-- Assume non-negativity of the allocations
variable (h_i_nonneg : ∀ i, 0 ≤ h_i_star i)
variable (h_j_nonneg : ∀ j, 0 ≤ h_j_star j)

-- Define the depletable constraint: Σ_i h_i = Σ_j h_j
def depletable_constraint : Prop :=
  ∑ i : I, h_i_star i = ∑ j : J, h_j_star j

-- Define the FOC for φ_i (condition 11.D.3)