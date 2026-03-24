import Mathlib
open Filter Topology
open Topology

theorem cournot_price_converges_to_mc (a c : ℝ) :
    Tendsto (fun J : ℕ => (a + ↑J * c) / (↑J + 1)) atTop (nhds c) := by
  rw [Metric.tendsto_nhds]
  intro ε hε
  rw [Filter.eventually_atTop]
  obtain ⟨N, hN⟩ := exists_nat_gt (|a - c| / ε)
  refine ⟨N, fun n hn => ?_⟩
  rw [Real.dist_eq]
  have hpos : (0 : ℝ) < ↑n + 1 := by positivity
  have hne : (↑n + 1 : ℝ) ≠ 0 := hpos.ne'
  have key : (a + ↑n * c) / (↑n + 1) - c = (a - c) / (↑n + 1) := by
    field_simp [hne]; ring
  rw [key, abs_div, abs_of_pos hpos]
  have h2 : (↑N : ℝ) ≤ ↑n := Nat.cast_le.mpr hn
  have h3 : |a - c| / ε < ↑n + 1 := by linarith
  have h5 : |a - c| < ε * (↑n + 1) := by
    have h4 : |a - c| / ε * ε = |a - c| := by field_simp [hε.ne']
    nlinarith [mul_lt_mul_of_pos_right h3 hε]
  have h6 : |a - c| / (↑n + 1) * (↑n + 1) = |a - c| := by field_simp [hne]
  have h7 : |a - c| / (↑n + 1) * (↑n + 1) < ε * (↑n + 1) := by linarith
  nlinarith