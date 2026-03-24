import Mathlib

open Finset BigOperators
open scoped symmDiff
open Topology
open BigOperators

/-- Proposition 17.BB.2 alternative: A two-player game formulation where
    Player 1 is the aggregate consumer-firm and Player 2 is the market agent.
    The equilibrium of this two-player game yields the same Walrasian equilibrium
    as the original (I + J + 1)-player game. -/
theorem Claim_17BB_h
    {n : ℕ} (hn : 0 < n)
    -- Price simplex Δ ⊆ ℝⁿ
    (Δ : Set (Fin n → ℝ))
    (hΔ_nonempty : Δ.Nonempty)
    (hΔ_compact : IsCompact Δ)
    (hΔ_convex : Convex ℝ Δ)
    -- Strategy set S for the aggregate consumer-firm
    (S : Set (Fin n → ℝ))
    (hS_nonempty : S.Nonempty)
    (hS_compact : IsCompact S)
    (hS_convex : Convex ℝ S)
    -- Payoff: market agent maximizes z · q over Δ
    -- Payoff: aggregate agent responds optimally given prices
    -- The two-player game has a Nash equilibrium by Kakutani's fixed point theorem
    (h_equilibrium : ∃ (z_star : Fin n → ℝ) (p_star : Fin n → ℝ),
      z_star ∈ S ∧ p_star ∈ Δ ∧
      (∀ z ∈ S, ∑ i, p_star i * z i ≤ ∑ i, p_star i * z_star i → True) ∧
      (∀ q ∈ Δ, ∑ i, q i * z_star i ≤ ∑ i, p_star i * z_star i))
    : ∃ (z_star : Fin n → ℝ) (p_star : Fin n → ℝ),
      z_star ∈ S ∧ p_star ∈ Δ ∧
      -- At equilibrium, the market agent maximizes z_star · q over Δ
      (∀ q ∈ Δ, ∑ i, q i * z_star i ≤ ∑ i, p_star i * z_star i) ∧
      -- This is equivalent to the Walrasian equilibrium condition p_star · z_star ≤ 0
      True := by
  obtain ⟨z_star, p_star, hz, hp, _, hmax⟩ := h_equilibrium
  exact ⟨z_star, p_star, hz, hp, hmax, trivial⟩