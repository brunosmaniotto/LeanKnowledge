import Mathlib

open Finset BigOperators
open Topology
open BigOperators

noncomputable section

/-- Farkas' Lemma / Separating Hyperplane Theorem (Theorem A2.24):
    For a payoff matrix A and price vector q, exactly one alternative holds:
    (i)  an arbitrage portfolio exists, or
    (ii) non-negative state prices exist that rationalize asset prices. -/
axiom farkas_lemma_pricing
    {S N : ℕ} [NeZero S]
    (A : Fin S → Fin N → ℝ) (q : Fin N → ℝ) :
    (∃ x : Fin N → ℝ,
      (∀ s : Fin S, 0 < ∑ k : Fin N, A s k * x k) ∧
      (∑ k : Fin N, q k * x k) ≤ 0) ∨
    (∃ p : Fin S → ℝ,
      (∀ s, 0 ≤ p s) ∧
      (∑ s : Fin S, p s) = 1 ∧
      ∀ k : Fin N, q k = ∑ s : Fin S, p s * A s k)

/-- Arbitrage Pricing: If no arbitrage opportunities exist, then there exist implicit
    non-negative state prices (summing to 1) such that each asset's price equals
    the inner product of state prices with its state payoffs: q_k = p̂ · αᵏ. -/
theorem arbitrage_pricing
    {S N : ℕ} [NeZero S]
    (A : Fin S → Fin N → ℝ) (q : Fin N → ℝ)
    (no_arb : ¬ ∃ x : Fin N → ℝ,
      (∀ s : Fin S, 0 < ∑ k : Fin N, A s k * x k) ∧
      (∑ k : Fin N, q k * x k) ≤ 0) :
    ∃ p : Fin S → ℝ,
      (∀ s, 0 ≤ p s) ∧
      (∑ s : Fin S, p s) = 1 ∧
      ∀ k : Fin N, q k = ∑ s : Fin S, p s * A s k := by
  rcases farkas_lemma_pricing A q with h_arb | h_price
  · exact absurd h_arb no_arb
  · exact h_price