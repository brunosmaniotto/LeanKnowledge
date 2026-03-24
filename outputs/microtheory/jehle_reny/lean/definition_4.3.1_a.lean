import Mathlib

noncomputable section

open Finset BigOperators
open Topology
open BigOperators

/-- A partial equilibrium model fixing prices of all goods except good q.
    - `u` is the full utility over (q, x) where x ∈ ℝⁿ are the other goods
    - `p_bar` is the fixed price vector for other goods
    - `x_demand` is the Marshallian demand for other goods given (price_of_q, income) -/
structure PartialEquilibriumModel (n : ℕ) where
  u : ℝ → (Fin n → ℝ) → ℝ
  p_bar : Fin n → ℝ
  x_demand : ℝ → ℝ → Fin n → ℝ

/-- The composite commodity: income spent on all goods other than q.
    m(p, y) ≡ p̄ · x(p, p̄, y) -/
noncomputable def PartialEquilibriumModel.compositeComm
    {n : ℕ} (M : PartialEquilibriumModel n) (p y : ℝ) : ℝ :=
  ∑ i : Fin n, M.p_bar i * M.x_demand p y i

/-- Conditional indirect utility: ū(q, m) ≡ max_x u(q, x) s.t. p̄ · x ≤ m -/
noncomputable def PartialEquilibriumModel.condIndirectUtil
    {n : ℕ} (M : PartialEquilibriumModel n) (q m : ℝ) : ℝ :=
  sSup {v | ∃ x : Fin n → ℝ, (∑ i, M.p_bar i * x i) ≤ m ∧ v = M.u q x}