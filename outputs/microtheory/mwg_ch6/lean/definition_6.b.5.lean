import Mathlib

open Finset BigOperators
open BigOperators

/-- A simple lottery over `N` outcomes: a probability distribution on `Fin N`. -/
structure SimpleLottery (N : ℕ) where
  prob : Fin N → ℝ
  nonneg : ∀ i, 0 ≤ prob i
  sum_one : ∑ i, prob i = 1

/-- A utility function `U : SimpleLottery N → ℝ` has the **expected utility form**
    (von Neumann–Morgenstern) if there exist Bernoulli utility values `(u₁, …, uₙ)`
    such that `U(L) = ∑ i, uᵢ · pᵢ` for every simple lottery `L`. -/
structure HasExpectedUtilityForm (N : ℕ) (U : SimpleLottery N → ℝ) where
  bernoulli : Fin N → ℝ
  eq_expected : ∀ L : SimpleLottery N, U L = ∑ i, bernoulli i * L.prob i