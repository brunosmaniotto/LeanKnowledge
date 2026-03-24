import Mathlib

open scoped BigOperators

/-- A one-consumer intertemporal economy as in MWG Section 20.D. -/
structure OneConsumerIntertemporalEconomy (L : ℕ) where
  /-- Short-term production technology Y ⊂ ℝ^(2L) -/
  productionSet : Set (Fin (2 * L) → ℝ)
  /-- Utility function on the nonneg orthant ℝ^L_+ -/
  utility : (Fin L → ℝ) → ℝ
  /-- Discount factor -/
  discountFactor : ℝ
  /-- Sequence of initial endowments indexed by time -/
  endowments : ℕ → (Fin L → ℝ)
  /-- Y is nonempty -/
  productionSet_nonempty : productionSet.Nonempty
  /-- Y is closed -/
  productionSet_closed : IsClosed productionSet
  /-- 0 ∈ Y (inaction is possible) -/
  zero_mem_productionSet : (0 : Fin (2 * L) → ℝ) ∈ productionSet
  /-- Y satisfies free disposal: if y ∈ Y and y' ≤ y then y' ∈ Y -/
  productionSet_free_disposal :
    ∀ y ∈ productionSet, ∀ y' : Fin (2 * L) → ℝ, y' ≤ y → y' ∈ productionSet
  /-- Discount factor is strictly between 0 and 1 -/
  discountFactor_pos : 0 < discountFactor
  discountFactor_lt_one : discountFactor < 1
  /-- Utility is strictly concave -/
  utility_strictConcave : StrictConcaveOn ℝ (Set.univ) utility
  /-- Utility is differentiable -/
  utility_differentiable :
    ∀ x : Fin L → ℝ, (∀ i, 0 < x i) → DifferentiableAt ℝ utility x
  /-- Strictly positive marginal utilities in the interior -/
  utility_strict_pos_marginal :
    ∀ x : Fin L → ℝ, (∀ i, 0 < x i) →
      ∀ j : Fin L, 0 < (fderiv ℝ utility x) (Function.update 0 j 1)
  /-- Endowments are nonnegative -/
  endowments_nonneg : ∀ t : ℕ, ∀ i : Fin L, 0 ≤ endowments t i
  /-- Endowment sequence is bounded -/
  endowments_bounded : ∃ M : ℝ, ∀ t : ℕ, ∀ i : Fin L, endowments t i ≤ M