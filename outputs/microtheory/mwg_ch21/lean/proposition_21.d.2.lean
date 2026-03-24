import Mathlib
open Topology

theorem Proposition_21D2
    {X : Type*} [DecidableEq X]
    (majority : X → X → Prop)
    (asymm : ∀ x y : X, x ≠ y → majority x y → ¬majority y x)
    (condorcet_on_triples : ∀ x y z : X,
      x ≠ y → y ≠ z → x ≠ z →
      ∃ w, (w = x ∨ w = y ∨ w = z) ∧
        ∀ v, (v = x ∨ v = y ∨ v = z) → v ≠ w → majority w v) :
    ∀ x y z : X, majority x y → majority y z → majority x z := by
  intro x y z hxy hyz
  by_cases hxy_eq : x = y
  · subst hxy_eq; exact hyz
  by_cases hyz_eq : y = z
  · subst hyz_eq; exact hxy
  by_cases hxz_eq : x = z
  · subst hxz_eq; exact absurd hyz (asymm x y hxy_eq hxy)
  obtain ⟨w, hw_mem, hw_defeats⟩ := condorcet_on_triples x y z hxy_eq hyz_eq hxz_eq
  rcases hw_mem with hw | hw | hw
  · -- w = x: x is Condorcet winner, need majority x z
    have hzw : z ≠ w := by rw [hw]; exact Ne.symm hxz_eq
    have h := hw_defeats z (Or.inr (Or.inr rfl)) hzw
    rw [hw] at h; exact h
  · -- w = y: y is Condorcet winner, but x beats y — contradiction
    have hxw : x ≠ w := by rw [hw]; exact hxy_eq
    have h := hw_defeats x (Or.inl rfl) hxw
    rw [hw] at h
    exact absurd h (asymm x y hxy_eq hxy)
  · -- w = z: z is Condorcet winner, but y beats z — contradiction
    have hyw : y ≠ w := by rw [hw]; exact hyz_eq
    have h := hw_defeats y (Or.inr (Or.inl rfl)) hyw
    rw [hw] at h
    exact absurd h (asymm y z hyz_eq hyz)