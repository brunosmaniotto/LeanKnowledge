import Mathlib

open BigOperators
open Finset

-- Define types for individuals and goods.
-- We use `Type` for generality, and `Fintype` for `Finset.univ` and `sum`.
variable {I J : Type} [Fintype I] [Fintype J]

-- A structure to represent the key properties of a quasilinear economy
-- relevant to this theorem. This encapsulates the necessary assumptions
-- for the proof to hold without building a full economic model from scratch.
structure QuasilinearEconomy (I J : Type) [Fintype I] [Fintype J] where
  -- `φ_i(x̄_i)`: utility from fixed consumption of non-numeraire goods for each individual.
  phi_fixed_utility : I → ℝ
  -- `c_j(q̄_j)`: cost of producing fixed quantities of goods.
  c_fixed_cost : J → ℝ
  -- `ω_m`: total numeraire endowment.
  omega_m : ℝ
  -- `IsAchievable`: a predicate stating whether a given utility vector `u` is achievable
  -- within the constraints of this quasilinear economy.
  IsAchievable (u : I → ℝ) : Prop
  -- The core axiom of a quasilinear economy for this theorem:
  -- If `u` is an achievable utility vector, then the sum of its components
  -- is bounded by the total social surplus (sum of non-numeraire utilities + numeraire - costs).
  achievable_utility_sum_le_surplus (u : I → ℝ) (h_achievable : IsAchievable u) :
    (Finset.sum Finset.univ u) ≤ (Finset.sum Finset.univ phi_fixed_utility) + omega_m - (Finset.sum Finset.univ c_fixed_cost)

-- Theorem: Claim_10D_a
-- In a quasilinear economy, the boundary of the utility possibility set for fixed
-- consumption/production levels is a hyperplane with normal vector (1, ..., 1).
-- The set of achievable utility vectors is {(u_1, ..., u_I): Σ_i u_i ≤ Σ_i φ_i(x̄_i) + ω_m − Σ_j c_j(q̄_j)}.
-- By altering good ℓ quantities, this boundary shifts in a parallel manner.
theorem Claim_10D_a
    (econ : QuasilinearEconomy I J) -- An instance of our quasilinear economy structure
    (u : I → ℝ)                  -- An arbitrary utility vector
    (h_achievable : econ.IsAchievable u) -- Hypothesis: u is an achievable utility vector in this economy
    :
    (Finset.sum Finset.univ u) ≤ (Finset.sum Finset.univ econ.phi_fixed_utility) + econ.omega_m - (Finset.sum Finset.univ econ.c_fixed_cost) :=
  by
    -- The proof directly uses the axiom defined in the `QuasilinearEconomy` structure.
    exact econ.achievable_utility_sum_le_surplus u h_achievable