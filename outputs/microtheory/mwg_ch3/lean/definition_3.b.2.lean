import Mathlib

variable {L : ℕ}

def VectorStrictDom (x y : Fin L → ℝ) : Prop := ∀ l, x l < y l