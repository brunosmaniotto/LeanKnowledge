import Mathlib.Data.Set.Basic

variable {α β γ δ : Type}

def comp (R : Set (α × β)) (S : Set (β × γ)) : Set (α × γ) :=
  { p | ∃ b, (p.1, b) ∈ R ∧ (b, p.2) ∈ S }