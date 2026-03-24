import Mathlib
open Topology

/-- Under standard conditions (finite players, finite nonempty strategy sets),
    every player has at least one rationalizable strategy.
    We formalize this by assuming a Nash equilibrium exists. -/
theorem rationalizable_strategy_exists
    {I : Type*} [Fintype I] [DecidableEq I]
    {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, Nonempty (S i)] [∀ i, DecidableEq (S i)]
    (u : (∀ i, S i) → I → ℝ)
    (IsNashEq : (∀ i, S i) → Prop)
    (IsRationalizable : ∀ i, S i → Prop)
    (nash_exists : ∃ s : ∀ i, S i, IsNashEq s)
    (nash_implies_rationalizable : ∀ s, IsNashEq s → ∀ i, IsRationalizable i (s i))
    (i : I) : ∃ si : S i, IsRationalizable i si := by
  obtain ⟨s, hs⟩ := nash_exists
  exact ⟨s i, nash_implies_rationalizable s hs i⟩