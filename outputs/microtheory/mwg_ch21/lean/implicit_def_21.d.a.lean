import Mathlib

/-- Pairwise majority voting rule on a domain of preference profiles.
    Given a profile of strict preference relations, x is socially at least as good as y
    if the number of agents strictly preferring x to y is at least the number strictly
    preferring y to x. -/
def pairwiseMajorityVoting {I X : Type*} [Fintype I] [DecidableEq I] [DecidableEq X]
    (strictPref : I → X → X → Prop) [∀ i x y, Decidable (strictPref i x y)]
    (x y : X) : Prop :=
  (Finset.univ.filter fun i => strictPref i x y).card ≥
  (Finset.univ.filter fun i => strictPref i y x).card