import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Aggregate excess demand for a production economy.
    For each commodity k, z_k(p) = Σ_i x^i_k(p, m^i(p)) − Σ_j y^j_k(p) − Σ_i e^i_k,
    where x^i is consumer i's demand, y^j is firm j's supply, e^i is consumer i's endowment,
    and m^i(p) is consumer i's income at prices p. -/
noncomputable def aggregateExcessDemand
    {I : Type*} [Fintype I]
    {J : Type*} [Fintype J]
    {n : ℕ}
    (x : I → (Fin n → ℝ) → ℝ → (Fin n → ℝ))   -- consumer i's demand given prices and income
    (y : J → (Fin n → ℝ) → (Fin n → ℝ))          -- firm j's supply given prices
    (e : I → (Fin n → ℝ))                          -- consumer i's endowment vector
    (m : I → (Fin n → ℝ) → ℝ)                     -- consumer i's income at prices p
    (p : Fin n → ℝ) : Fin n → ℝ :=
  fun k =>
    ∑ i : I, (x i p (m i p)) k
    - ∑ j : J, (y j p) k
    - ∑ i : I, (e i) k