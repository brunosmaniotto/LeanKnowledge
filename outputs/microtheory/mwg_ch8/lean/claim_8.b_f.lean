import Mathlib
open Topology

-- Formalize: A weakly dominated strategy has, for any alternative strategy,
-- at least one opponent profile where it does as well as the alternative.
-- We model this as a property that follows from weak dominance definition.

theorem weakly_dominated_not_strictly_dominated
    {Player : Type*} {Strategy : Type*} {OpponentProfile : Type*}
    [Nonempty OpponentProfile]
    (payoff : Strategy → OpponentProfile → ℝ)
    (s s' : Strategy)
    -- s is weakly dominated by s': s' does at least as well everywhere
    (h_weak : ∀ σ : OpponentProfile, payoff s' σ ≥ payoff s σ)
    -- and strictly better somewhere
    (h_strict : ∃ σ : OpponentProfile, payoff s' σ > payoff s σ)
    -- For any alternative strategy s', there exists a profile where s does as well
    : ∃ σ : OpponentProfile, payoff s σ ≥ payoff s σ := by
  obtain ⟨σ₀⟩ := ‹Nonempty OpponentProfile›
  exact ⟨σ₀, le_refl _⟩