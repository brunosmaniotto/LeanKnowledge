import Mathlib

/-- A pure strategy may be strictly dominated only by a mixed strategy.
    We exhibit a 3×2 game where strategy M is not dominated by U or D alone,
    but is strictly dominated by (1/2)U + (1/2)D. -/
theorem pure_strategy_dominated_only_by_mixed :
    -- Payoff matrix: rows = {U, M, D}, cols = {L, R}
    -- U: (10, 0), M: (4, 4), D: (0, 10)
    -- We show:
    -- (1) U does not dominate M (fails on column R)
    -- (2) D does not dominate M (fails on column L)
    -- (3) (1/2)U + (1/2)D strictly dominates M (yields 5 > 4 in both columns)
    let u_L : ℚ := 10; let u_R : ℚ := 0
    let m_L : ℚ := 4;  let m_R : ℚ := 4
    let d_L : ℚ := 0;  let d_R : ℚ := 10
    let mix_L := (1/2) * u_L + (1/2) * d_L
    let mix_R := (1/2) * u_R + (1/2) * d_R
    (¬(u_L > m_L ∧ u_R > m_R)) ∧
    (¬(d_L > m_L ∧ d_R > m_R)) ∧
    (mix_L > m_L ∧ mix_R > m_R) := by
  refine ⟨by norm_num, by norm_num, by norm_num, by norm_num⟩