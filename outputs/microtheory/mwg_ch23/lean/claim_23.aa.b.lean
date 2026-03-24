import Mathlib

variable {Outcome Mechanism Equilibrium : Type*}

def WeaklyImplements (equilOf : Mechanism → Set Equilibrium)
    (outcome : Mechanism → Equilibrium → Outcome)
    (goal : Set Outcome) (m : Mechanism) : Prop :=
  ∃ e ∈ equilOf m, outcome m e ∈ goal