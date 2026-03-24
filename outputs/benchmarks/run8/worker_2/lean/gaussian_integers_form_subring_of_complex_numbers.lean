import Mathlib

open Complex

def gaussianIntSubring : Subring ℂ where
  carrier := {z | ∃ (a b : ℤ), z = (a : ℂ) + (b : ℂ) * I}
  zero_mem' := ⟨0, 0, by simp⟩
  one_mem' := ⟨1, 0, by simp⟩
  add_mem' := by
    rintro x y ⟨a₁, b₁, rfl⟩ ⟨a₂, b₂, rfl⟩
    refine ⟨a₁ + a₂, b₁ + b₂, ?_⟩
    push_cast
    ring
  neg_mem' := by
    rintro x ⟨a, b, rfl⟩
    refine ⟨-a, -b, ?_⟩
    push_cast
    ring
  mul_mem' := by
    rintro x y ⟨a₁, b₁, rfl⟩ ⟨a₂, b₂, rfl⟩
    refine ⟨a₁ * a₂ - b₁ * b₂, a₁ * b₂ + b₁ * a₂, ?_⟩
    push_cast
    ring_nf
    rw [Complex.I_sq]
    push_cast
    ring