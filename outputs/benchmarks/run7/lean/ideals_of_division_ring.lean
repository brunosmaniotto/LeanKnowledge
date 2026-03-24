import Mathlib.RingTheory.Ideal.Basic

variable (R : Type _) [DivisionRing R]

theorem ideals_of_division_ring : ∀ (I : Ideal R), I = ⊥ ∨ I = ⊤ :=
  Ideal.eq_bot_or_top