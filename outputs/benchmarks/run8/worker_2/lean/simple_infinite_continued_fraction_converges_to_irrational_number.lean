import Mathlib

structure SimpleContinuedFraction where
  seq : ℕ → ℕ
  pos : ∀ n, 0 < seq n

noncomputable def SimpleContinuedFraction.value (scf : SimpleContinuedFraction) : ℝ :=
  0

theorem SimpleContinuedFraction.irrational_of_infinite (scf : SimpleContinuedFraction) :
    Irrational (scf.value) := by
  sorry