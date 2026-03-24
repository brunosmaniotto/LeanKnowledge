import Mathlib

variable (R : Type u) [Ring R] [Nontrivial R]

abbrev nonZero : Type u := {x : R // x ≠ 0}

theorem noZeroDivisors_iff_semigroup :
    NoZeroDivisors R ↔ ∃ (S : Semigroup (nonZero R)), ∀ a b : nonZero R, (a * b).val = a.val * b.val := by
  constructor
  · intro h
    letI : NoZeroDivisors R := h
    letI : Mul (nonZero R) :=
      { mul := fun a b => ⟨a.val * b.val, mul_ne_zero a.property b.property⟩ }
    letI : Semigroup (nonZero R) :=
      { mul := (· * ·)
        mul_assoc := by
          intro a b c
          ext
          exact mul_assoc (a : R) (b : R) (c : R) }
    exact ⟨inferInstance, fun _ _ => rfl⟩
  · rintro ⟨S, hS⟩
    letI : Semigroup (nonZero R) := S
    refine ⟨fun {a b} h0 => ?_⟩
    by_contra! H
    have ha : a ≠ 0 := H.1
    have hb : b ≠ 0 := H.2
    let a' : nonZero R := ⟨a, ha⟩
    let b' : nonZero R := ⟨b, hb⟩
    have h1 : (a' * b').val = 0 := by rw [hS, h0]
    have h2 : (a' * b').val ≠ 0 := (a' * b').property
    exact h2 h1