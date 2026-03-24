import Mathlib

open Matrix
open Finset

variable {R : Type} [Ring R]
variable {m n p q : Type} [Fintype n] [Fintype p]

theorem matrix_mul_assoc (A : Matrix m n R) (B : Matrix n p R) (C : Matrix p q R) :
    (A * B) * C = A * (B * C) := by
  ext i j
  simp only [Matrix.mul_apply]
  calc
    ∑ k ∈ univ, (∑ l ∈ univ, A i l * B l k) * C k j
        = ∑ k ∈ univ, ∑ l ∈ univ, (A i l * B l k) * C k j := by
          simp [Finset.sum_mul]
    _ = ∑ k ∈ univ, ∑ l ∈ univ, A i l * (B l k * C k j) := by
          simp [mul_assoc]
    _ = ∑ l ∈ univ, ∑ k ∈ univ, A i l * (B l k * C k j) := by
          rw [Finset.sum_comm]
    _ = ∑ l ∈ univ, A i l * (∑ k ∈ univ, B l k * C k j) := by
          simp [Finset.mul_sum]
    _ = ∑ l ∈ univ, A i l * ((B * C) l j) := rfl