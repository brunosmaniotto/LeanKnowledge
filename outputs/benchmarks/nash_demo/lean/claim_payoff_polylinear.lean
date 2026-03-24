import Mathlib

open BigOperators
open Topology

/-- The expected payoff in a finite game is polylinear (multilinear) in the players'
    mixed strategies. For any player k, the payoff is linear in k's probability vector
    while holding other players' strategies fixed. Here Ω models the set of pure strategy
    profiles, A is one player's action set, proj extracts that player's action, and
    r(s) = (∏_{i≠k} σ_i(s_i)) · u(s) collects all terms independent of that player. -/
theorem Claim_payoff_polylinear
    {Ω : Type*} [Fintype Ω]
    {A : Type*}
    (proj : Ω → A)
    (r : Ω → ℝ)
    (σ₁ σ₂ : A → ℝ)
    (α β : ℝ) :
    (∑ s : Ω, (α * σ₁ (proj s) + β * σ₂ (proj s)) * r s) =
    α * (∑ s, σ₁ (proj s) * r s) + β * (∑ s, σ₂ (proj s) * r s) := by
  simp_rw [add_mul, mul_assoc, Finset.sum_add_distrib, ← Finset.mul_sum]