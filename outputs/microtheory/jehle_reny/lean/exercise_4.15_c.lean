import Mathlib
open Topology

/-- The long-run Nash equilibrium number of firms in monopolistic competition
    is uniquely determined by the zero-profit and best-response conditions.
    When per-firm equilibrium profit strictly decreases with the number of firms,
    exactly one firm count yields zero profit. -/
theorem Exercise_4_15_c
    (profit : ℕ → ℝ)
    (h_decreasing : StrictAnti profit)
    (h_exists : ∃ J : ℕ, J > 0 ∧ profit J = 0)
    : ∃! J_star : ℕ, J_star > 0 ∧ profit J_star = 0 := by
  obtain ⟨J, hJ_pos, hJ_zero⟩ := h_exists
  refine ⟨J, ⟨hJ_pos, hJ_zero⟩, ?_⟩
  intro k ⟨_, hk_zero⟩
  by_contra hne
  rcases lt_or_gt_of_ne hne with h | h
  · linarith [h_decreasing h]
  · linarith [h_decreasing h]