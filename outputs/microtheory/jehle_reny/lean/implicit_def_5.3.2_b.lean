import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {I J L : Type*} [Fintype I] [Fintype J] [Fintype L]

/-- Consumer i's income in a private ownership production economy:
    m^i(p) = p · e^i + ∑_j θ^{ij} · π_j(p)
    Combines endowment income and profit share income. (MWG Eq. 5.4) -/
noncomputable def consumerIncome
    (e : L → ℝ)             -- consumer's endowment vector
    (θ : J → ℝ)             -- consumer's ownership shares in each firm
    (π : J → (L → ℝ) → ℝ)  -- firm profit functions (price → profit)
    (p : L → ℝ)             -- price vector
    : ℝ :=
  (∑ l : L, p l * e l) + ∑ j : J, θ j * π j p

/-- Consumer's budget set in a private ownership economy:
    B^i(p) = { x ∈ ℝ^L | p · x ≤ m^i(p) } -/
noncomputable def consumerBudgetSet
    (e : L → ℝ)
    (θ : J → ℝ)
    (π : J → (L → ℝ) → ℝ)
    (p : L → ℝ)
    : Set (L → ℝ) :=
  {x | ∑ l : L, p l * x l ≤ consumerIncome e θ π p}