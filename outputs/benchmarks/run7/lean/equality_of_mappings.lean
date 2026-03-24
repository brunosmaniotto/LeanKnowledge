import Mathlib

variable {α β : Type _}
variable (S1 S2 : Set α) (T1 T2 : Set β)
variable (f1 f2 : α → β)

/-- The graph of a function `f` restricted to domain `S` and codomain `T`. -/
def graph (f : α → β) (S : Set α) (T : Set β) : Set (α × β) :=
  { p | p.1 ∈ S ∧ p.2 ∈ T ∧ f p.1 = p.2 }