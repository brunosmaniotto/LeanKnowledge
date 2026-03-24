import Mathlib

/-- A social choice function assigns a collective choice in `X` to each profile
of agent types. Agent types are indexed by `I`, with agent `i` having type space `Θ i`,
and `X` is the set of alternatives. -/
def SocialChoiceFunction (I : Type*) (Θ : I → Type*) (X : Type*) :=
  (∀ i, Θ i) → X