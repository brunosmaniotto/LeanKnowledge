import Mathlib

/-- The Betweenness Axiom (MWG Exercise 6.B.5): For all lotteries L, L' and
    λ ∈ (0,1), if L is indifferent to L', then the mixture λL + (1-λ)L'
    is also indifferent to L. This is weaker than the independence axiom. -/
def BetweennessAxiom
    {Lottery : Type*}
    (pref : Lottery → Lottery → Prop)
    (mix : Lottery → Lottery → Set.Ioo (0:ℝ) 1 → Lottery) : Prop :=
  ∀ (L L' : Lottery) (lam : Set.Ioo (0:ℝ) 1),
    (pref L L' ∧ pref L' L) →
    (pref (mix L L' lam) L ∧ pref L (mix L L' lam))