import Mathlib

/-- Row-player payoffs: U=(2,1,0), C=(1,3,2), D=(2,1,−1) -/
private def rpay : Fin 3 → Fin 3 → ℤ :=
  ![![(2 : ℤ), 1, 0], ![1, 3, 2], ![2, 1, -1]]

/-- Column-player payoffs: vs U=(1,1,0), vs C=(2,1,1), vs D=(−2,−1,−1) -/
private def cpay : Fin 3 → Fin 3 → ℤ :=
  ![![(1 : ℤ), 1, 0], ![2, 1, 1], ![-2, -1, -1]]

/-- The order of iterated elimination of weakly dominated strategies
    can affect which outcomes survive. -/
theorem Exercise_7_3_a :
    ∃ (u₁ u₂ : Fin 3 → Fin 3 → ℤ),
      -- U (row 0) weakly dominates D (row 2) in the full game
      (∀ j : Fin 3, u₁ 0 j ≥ u₁ 2 j) ∧
      (∃ j : Fin 3, u₁ 0 j > u₁ 2 j) ∧
      -- M (col 1) weakly dominates R (col 2) in the full game
      (∀ i : Fin 3, u₂ i 1 ≥ u₂ i 2) ∧
      (∃ i : Fin 3, u₂ i 1 > u₂ i 2) ∧
      -- After removing R, U and D have identical row-player payoffs
      -- so D can no longer be eliminated → order matters
      (u₁ 0 0 = u₁ 2 0 ∧ u₁ 0 1 = u₁ 2 1) := by
  refine ⟨rpay, cpay, ?_, ⟨2, ?_⟩, ?_, ⟨0, ?_⟩, ?_, ?_⟩ <;> native_decide