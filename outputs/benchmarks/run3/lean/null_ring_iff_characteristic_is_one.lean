import Mathlib
open Topology

theorem charP_one_iff_subsingleton (R : Type u) [Ring R] : CharP R 1 ↔ Subsingleton R := by
  constructor
  · intro h
    have h1 : (1 : R) = 0 := by
      rw [← Nat.cast_one, CharP.cast_eq_zero R 1]
    constructor
    intro a b
    calc
      a = a * (1 : R) := by rw [mul_one]
      _ = a * (0 : R) := by rw [h1]
      _ = 0 := by rw [mul_zero]
      _ = b * (0 : R) := by rw [mul_zero]
      _ = b * (1 : R) := by rw [h1]
      _ = b := by rw [mul_one]
  · intro h
    have : ∀ (x : ℕ), (x : R) = 0 := by
      intro x
      exact Subsingleton.elim (x : R) 0
    exact
      { cast_eq_zero_iff := fun x =>
          ⟨fun _ => Nat.one_dvd x, fun _ => this x⟩ }