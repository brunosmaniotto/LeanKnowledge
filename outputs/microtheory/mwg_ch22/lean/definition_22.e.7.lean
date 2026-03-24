import Mathlib

/-- A bargaining solution satisfies Independence of Irrelevant Alternatives (IIA)
if whenever U' ⊂ U and f(U) ∈ U', then f(U') = f(U). -/
def SatisfiesIIA {α : Type*} (f : Set α → α) : Prop :=
  ∀ (U U' : Set α), U' ⊆ U → f U ∈ U' → f U' = f U