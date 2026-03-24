import Mathlib

open BigOperators Finset

/-- Axiom G6 (Reduction to Simple Gambles): For any gamble `g ∈ G`,
    the decision maker is indifferent between `g` and the simple gamble
    `(p₁ ∘ a₁, …, pₙ ∘ aₙ)` it induces — only effective probabilities
    over final outcomes matter. -/
def ReductionToSimpleGambles
    {G : Type*}
    (reduce : G → G)
    (indiff : G → G → Prop) : Prop :=
  ∀ g : G, indiff (reduce g) g