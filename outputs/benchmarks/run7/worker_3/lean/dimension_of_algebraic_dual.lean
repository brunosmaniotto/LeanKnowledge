import Mathlib

open FiniteDimensional Module

theorem dimension_of_algebraic_dual
    (R : Type*) [Field R]
    (G : Type*) [AddCommGroup G] [Module R G]
    [h_fd : FiniteDimensional R G]
    (n : ℕ) (h_n : finrank R G = n) :
    finrank R (Dual R G) = n ∧ finrank R (Dual R (Dual R G)) = n := by
  have h1 : finrank R (Dual R G) = n :=
    calc
      finrank R (Dual R G) = finrank R (G →ₗ[R] R) := by rfl
      _ = finrank R G * finrank R R := by rw [finrank_linearMap]
      _ = n * finrank R R := by rw [h_n]
      _ = n * 1 := by rw [finrank_self]
      _ = n := by simp
  have h2 : finrank R (Dual R (Dual R G)) = n :=
    calc
      finrank R (Dual R (Dual R G)) = finrank R (Dual R G →ₗ[R] R) := by rfl
      _ = finrank R (Dual R G) * finrank R R := by rw [finrank_linearMap]
      _ = n * finrank R R := by rw [h1]
      _ = n * 1 := by rw [finrank_self]
      _ = n := by simp
  exact ⟨h1, h2⟩