import Mathlib
open Topology

-- Firm j's optimal production maximizes profit over its production set
-- We formalize: given that y_star_j maximizes p · y among all y in Y_j,
-- then for all y_j in Y_j, p · y_j ≤ p · y_star_j

theorem Claim_16D_step7
    {V : Type*} [AddCommMonoid V] [Module ℝ V]
    {J : Type*} [Fintype J]
    (p : V → ℝ)
    (hp_linear : ∀ u v : V, p (u + v) = p u + p v)
    (Y : J → Set V)
    (y_star : J → V)
    (h_mem : ∀ j, y_star j ∈ Y j)
    (h_profit_max : ∀ j, ∀ y_j ∈ Y j, p y_j ≤ p (y_star j)) :
    ∀ j, ∀ y_j ∈ Y j, p y_j ≤ p (y_star j) := by
  exact h_profit_max