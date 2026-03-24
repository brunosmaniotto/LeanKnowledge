import Mathlib

open Matrix
open Topology

/-- The characteristic values (eigenvalues) of symmetric matrices are always real. -/
theorem characteristic_values_of_symmetric_are_real
    {n : Type*} [Fintype n] [DecidableEq n]
    (M : Matrix n n ℝ) (hM : M.IsHermitian) :
    ∀ i : n, ∃ r : ℝ, (hM.eigenvalues i : ℂ) = (r : ℂ) := by
  intro i
  exact ⟨hM.eigenvalues i, by simp⟩