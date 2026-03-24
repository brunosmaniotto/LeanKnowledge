import Mathlib

theorem ringHom_is_addGroupHom {R S : Type _} [Ring R] [Ring S] (φ : R →+* S) :
    (∀ x y, φ (x + y) = φ x + φ y) ∧ φ 0 = 0 ∧ ∀ x, φ (-x) = -φ x :=
  ⟨φ.map_add, φ.map_zero, φ.map_neg⟩