import Mathlib
open Topology

/-- A mixed strategy that randomizes over undominated pure strategies may itself be dominated.
    We construct a 3×2 game where pure strategies U and D are undominated,
    but (1/2)U + (1/2)D is strictly dominated by M.
    Payoff matrix:
      U: (10, 0)
      M: (6, 6)
      D: (0, 10)
    U is not dominated (beats M and D vs column 1).
    D is not dominated (beats M and U vs column 2).
    But (1/2)U + (1/2)D gives (5, 5), which is strictly dominated by M's (6, 6). -/
theorem mixed_strategy_over_undominated_can_be_dominated :
    let u : Fin 2 → ℚ := ![10, 0]
    let m : Fin 2 → ℚ := ![6, 6]
    let d : Fin 2 → ℚ := ![0, 10]
    let mix : Fin 2 → ℚ := fun j => (1/2) * u j + (1/2) * d j
    -- U is not dominated by M (U beats M in column 0)
    (∃ j : Fin 2, m j < u j) ∧
    -- D is not dominated by M (D beats M in column 1)
    (∃ j : Fin 2, m j < d j) ∧
    -- But (1/2)U + (1/2)D is strictly dominated by M
    (∀ j : Fin 2, mix j < m j) := by
  refine ⟨⟨0, by norm_num [Matrix.cons_val_zero]⟩,
          ⟨1, by norm_num [Matrix.cons_val_one, Matrix.cons_val_fin_one]⟩,
          fun j => ?_⟩
  fin_cases j <;> norm_num [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_fin_one]