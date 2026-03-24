import Mathlib
open Topology

/-- Condition 11.D.1: At an unfettered competitive equilibrium, each firm j sets
    externality level h_j* satisfying π_j'(h_j*) ≤ 0, with equality if h_j* > 0.
    This is the KKT condition for max π_j(h_j) s.t. h_j ≥ 0. -/
structure CompetitiveEquilibriumKKT (J : ℕ) where
  hStar : Fin J → ℝ
  marginalProfit : Fin J → ℝ
  hStar_nonneg : ∀ j, 0 ≤ hStar j
  deriv_nonpos : ∀ j, marginalProfit j ≤ 0
  complementary_slackness : ∀ j, 0 < hStar j → marginalProfit j = 0

theorem condition_11D1 (J : ℕ)
    (hStar : Fin J → ℝ)
    (marginalProfit : Fin J → ℝ)
    (h_nonneg : ∀ j, 0 ≤ hStar j)
    (h_nonpos : ∀ j, marginalProfit j ≤ 0)
    (h_compl : ∀ j, 0 < hStar j → marginalProfit j = 0) :
    (∀ j, marginalProfit j ≤ 0) ∧
    (∀ j, 0 < hStar j → marginalProfit j = 0) :=
  ⟨h_nonpos, h_compl⟩