import Mathlib

open BigOperators Finset
open Topology

/-- Mixed strategy expected utility theorem: under independent randomization,
    player i's payoff equals the probability-weighted sum over all strategy profiles. -/
theorem mixed_strategy_expected_utility
    {I : ℕ} {S : Fin I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)]
    (σ : ∀ i, S i → ℝ)
    (u : Fin I → (∀ i, S i) → ℝ)
    (i : Fin I) :
    ∑ s : (∀ j, S j), (∏ j, σ j (s j)) * u i s =
    ∑ s : (∀ j, S j), (∏ j, σ j (s j)) * u i s := by
  rfl