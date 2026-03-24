import Mathlib

variable {G : Type*} [Group G]

-- Define what it means to be a congruence relation
def IsCongruence (R : G → G → Prop) : Prop :=
  Equivalence R ∧ ∀ a b c d, R a b → R c d → R (a * c) (b * d)

-- Define the equivalence class of the identity