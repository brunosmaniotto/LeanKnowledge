import Mathlib

variable {S : Type} [Semigroup S]

/-- The subsemigroup of cancellable elements in a semigroup `S`. -/
def cancellativeSubsemigroup : Subsemigroup S where
  carrier := {a | Function.Injective (a * ·) ∧ Function.Injective (· * a)}
  mul_mem' := by
    intro a b ha hb
    refine ⟨?_, ?_⟩
    · -- Show `a * b` is left cancellable
      intro x y h
      apply hb.1
      apply ha.1
      simpa [mul_assoc] using h
    · -- Show `a * b` is right cancellable
      intro x y h
      apply ha.2
      apply hb.2
      simpa [mul_assoc] using h