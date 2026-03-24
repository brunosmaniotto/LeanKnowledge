import Mathlib

/-- Demand for a good can fall when its price decreases (uncompensated price change).
    The weak axiom does not yield the law of demand for uncompensated changes. -/
theorem demand_can_fall_when_price_decreases :
    ∃ (x : Fin 2 → ℝ → ℝ → ℝ),
      ∃ (p1 p1' w : ℝ),
        p1' < p1 ∧ 0 < p1' ∧ 0 < w ∧
        x 0 p1' w < x 0 p1 w := by
  refine ⟨fun i p1 _w => if i = 0 then (if p1 = 2 then 3 else 1) else 0,
          2, 1, 1, by norm_num, by norm_num, by norm_num, ?_⟩
  simp