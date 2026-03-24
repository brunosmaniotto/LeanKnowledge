import Mathlib

variable {S : Type _} [Mul S]

theorem Con.quotient_map_is_epimorphism (c : Con S) :
    Function.Surjective c.toQuotient ∧ ∀ x y, c.toQuotient (x * y) = c.toQuotient x * c.toQuotient y := by
  constructor
  · intro x
    induction' x using Quotient.inductionOn' with y
    exact ⟨y, rfl⟩
  · intro x y
    rfl