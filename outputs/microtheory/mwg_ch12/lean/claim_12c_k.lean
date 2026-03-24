import Mathlib

open Filter Topology Metric Set
open Topology

theorem Claim_12C_k (c : ℝ) (D : ℝ → ℝ)
  (h_D_continuous : Continuous D)
  (h_D_pos_at_c : D c > 0)
  (h_D_non_negative : ∀ p, D p ≥ 0)
  (p_star : ℝ)
  (h_p_star_maximizes_profit : ∀ p, (p_star - c) * D p_star ≥ (p - c) * D p)
  : p_star > c := by

  -- By continuity of `D` and `D c > 0`, `D` is positive in a neighborhood of `c`.
  have h_eventually_D_pos : ∀ᶠ p' in 𝓝 c, D p' > 0 :=
    (h_D_continuous.tendsto c).eventually (Ioi_mem_nhds h_D_pos_at_c)

  -- This implies there is a `δ > 0` such that for `p` in `ball c δ`, `D p > 0`.
  obtain ⟨δ, hδ_pos, h_ball_subset⟩ := eventually_nhds_iff_ball.mp h_eventually_D_pos

  -- Consider a price `p_prime` slightly above `c`.
  let p_prime := c + δ / 2

  -- This price `p_prime` is within the neighborhood `ball c δ`.
  have p_prime_in_ball : p_prime ∈ ball c δ := by
    simp only [mem_ball, dist_eq_norm, p_prime, add_sub_cancel_left, Real.norm_eq_abs]
    rw [abs_of_pos (half_pos hδ_pos)]
    exact half_lt_self hδ_pos

  -- Therefore, demand at `p_prime` is strictly positive.
  have D_p_prime_pos : D p_prime > 0 := h_ball_subset p_prime p_prime_in_ball

  -- And profit at `p_prime` is strictly positive.
  have profit_p_prime_pos : (p_prime - c) * D p_prime > 0 := by
    apply mul_pos
    · simp [p_prime, half_pos hδ_pos]
    · exact D_p_prime_pos

  -- Since `p_star` maximizes profit, its profit is at least the profit of `p_prime`.
  have profit_p_star_ge_profit_p_prime : (p_star - c) * D p_star ≥ (p_prime - c) * D p_prime :=
    h_p_star_maximizes_profit p_prime

  -- Thus, the profit at `p_star` must be strictly positive.
  have profit_p_star_pos : (p_star - c) * D p_star > 0 :=
    lt_of_lt_of_le profit_p_prime_pos profit_p_star_ge_profit_p_prime

  -- From `(p_star - c) * D p_star > 0` and `D p_star ≥ 0`, we deduce `p_star - c > 0`.
  have p_star_sub_c_pos : p_star - c > 0 :=
    pos_of_mul_pos_left profit_p_star_pos (h_D_non_negative p_star)

  -- `p_star - c > 0` is the same as `p_star > c`.
  exact lt_of_sub_pos p_star_sub_c_pos