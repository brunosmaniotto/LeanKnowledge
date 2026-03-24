import Mathlib

open Ideal

theorem quotient_ring_with_unity (R : Type u) [CommRing R] (J : Ideal R) :
    ∃ (one : R ⧸ J), (∀ x : R ⧸ J, one * x = x ∧ x * one = x) ∧ one = Ideal.Quotient.mk J 1 := by
  refine ⟨1, λ x => ⟨one_mul x, mul_one x⟩, rfl⟩