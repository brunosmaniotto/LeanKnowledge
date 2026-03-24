import Mathlib
open Topology

-- Maximin SWF: society ranks alternatives by their minimum utility across individuals.
-- Paretian: if all individuals strictly prefer x to y (u_i(x) > u_i(y) for all i),
--   then society strictly prefers x (min u(x) > min u(y)).
-- Not strictly Paretian: there exist profiles where all weakly prefer x and some strictly,
--   yet society is indifferent (min u(x) = min u(y)).

theorem maximin_paretian_not_strictly_paretian :
    -- Part 1: Paretian property
    (∀ (u v : Fin 2 → ℤ), (∀ i, u i > v i) → min (u 0) (u 1) > min (v 0) (v 1)) ∧
    -- Part 2: Not strictly Paretian (counterexample exists)
    (∃ (u v : Fin 2 → ℤ), (∀ i, u i ≥ v i) ∧ (∃ i, u i > v i) ∧
      min (u 0) (u 1) = min (v 0) (v 1)) := by
  constructor
  · intro u v h
    have h0 := h 0
    have h1 := h 1
    omega
  · refine ⟨![1, 2], ![1, 1], ?_, ?_, ?_⟩
    · intro i; fin_cases i <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]
    · exact ⟨1, by simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]⟩
    · simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]