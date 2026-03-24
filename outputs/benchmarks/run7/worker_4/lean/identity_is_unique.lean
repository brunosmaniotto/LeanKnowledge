import Mathlib

variable {S : Type} [Mul S]

theorem identity_unique (e₁ e₂ : S) (h_left : ∀ x, e₂ * x = x) (h_right : ∀ x, x * e₁ = x) : e₁ = e₂ := by
  calc
    e₁ = e₂ * e₁ := Eq.symm (h_left e₁)
    _ = e₂ := h_right e₂