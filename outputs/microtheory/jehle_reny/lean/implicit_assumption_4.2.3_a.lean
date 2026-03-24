import Mathlib

open Topology Filter

/-- Assumption 4.2.3(a): Free entry with close substitutes in monopolistic competition.
    Each product variant has arbitrarily close substitutes producible at the same cost,
    so positive long-run profits induce entry of arbitrarily many close-substitute firms. -/
structure FreeEntryCloseSubstitutes
    (Product : Type*) [MetricSpace Product]
    (cost : Product → ℝ)
    (longRunProfit : Product → ℝ) where
  /-- Every product has arbitrarily close substitutes producible at the same cost. -/
  close_substitutes : ∀ (p : Product) (ε : ℝ), ε > 0 →
    ∃ q : Product, q ≠ p ∧ dist q p < ε ∧ cost q = cost p
  /-- Positive long-run profit for any firm induces entry of arbitrarily many
      firms producing close substitutes (within any ε-ball, at the same cost). -/
  entry_on_positive_profit : ∀ (p : Product) (ε : ℝ) (N : ℕ),
    ε > 0 → longRunProfit p > 0 →
    ∃ S : Finset Product, S.card ≥ N ∧
      ∀ q ∈ S, q ≠ p ∧ dist q p < ε ∧ cost q = cost p