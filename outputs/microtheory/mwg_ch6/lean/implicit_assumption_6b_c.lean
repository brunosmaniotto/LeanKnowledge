import Mathlib

/-- The consequentialist premise: for any compound lottery over final outcomes in `Ω`,
    only the reduced (simple) lottery matters to the decision maker. Two compound
    lotteries that yield the same reduced lottery are treated as equivalent.

    A compound lottery is `PMF (PMF Ω)` — a probability distribution over simple
    lotteries. Its reduction to a simple lottery `PMF Ω` is given by `PMF.bind id`,
    which marginalizes out the intermediate lottery structure. -/
structure ConsequentialistPremise (Ω : Type*) where
  /-- Weak preference over compound lotteries (lotteries over simple lotteries) -/
  weakPref : PMF (PMF Ω) → PMF (PMF Ω) → Prop
  /-- Two compound lotteries reducing to the same simple lottery are indifferent -/
  reduction_indifference : ∀ (c₁ c₂ : PMF (PMF Ω)),
    c₁.bind id = c₂.bind id →
    weakPref c₁ c₂ ∧ weakPref c₂ c₁