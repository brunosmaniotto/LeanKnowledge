import Mathlib

variable {Player : Type} [DecidableEq Player] {S : Player → Type}

def StrictlyDominated (u : (∀ i, S i) → ℝ) (i : Player) (si : S i) : Prop :=
  ∃ si' : S i, ∀ σ : ∀ j, S j, u (Function.update σ i si') > u (Function.update σ i si)