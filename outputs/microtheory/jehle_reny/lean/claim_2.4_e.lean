import Mathlib
open Topology

/-- Axioms G6 (reduction of compound lotteries) and G2 (transitivity) together imply
    that preferences over all gambles are completely determined by preferences over
    simple gambles: g₁ ≿ g₂ iff reduce(g₁) ≿ reduce(g₂). -/
theorem Claim_2_4_e
    {Gamble SimpleLottery : Type*}
    (reduce : Gamble → SimpleLottery)
    (embed : SimpleLottery → Gamble)
    (pref : Gamble → Gamble → Prop)
    -- G2: preferences are transitive
    (G2_trans : Transitive pref)
    -- G6: every gamble is indifferent to its reduced simple gamble
    (G6_to_simple : ∀ g, pref g (embed (reduce g)))
    (G6_from_simple : ∀ g, pref (embed (reduce g)) g) :
    ∀ g₁ g₂, pref g₁ g₂ ↔ pref (embed (reduce g₁)) (embed (reduce g₂)) := by
  intro g₁ g₂
  constructor
  · intro h
    exact G2_trans (G6_from_simple g₁) (G2_trans h (G6_to_simple g₂))
  · intro h
    exact G2_trans (G6_to_simple g₁) (G2_trans h (G6_from_simple g₂))