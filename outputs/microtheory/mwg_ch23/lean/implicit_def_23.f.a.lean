import Mathlib

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {Θ : I → Type*} [∀ i, Fintype (Θ i)] [∀ i, DecidableEq (Θ i)]
variable {X : Type*}

abbrev SocialChoiceFunction (Θ : I → Type*) (X : Type*) := (∀ i, Θ i) → X

def F_BIC (isBIC : SocialChoiceFunction Θ X → Prop) : Set (SocialChoiceFunction Θ X) :=
  {f | isBIC f}