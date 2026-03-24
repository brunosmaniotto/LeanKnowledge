import Mathlib

theorem Example_9AA2_Infinite_Bargaining
    (v δ : ℝ)
    (hv : 0 < v)
    (hδ_pos : 0 < δ)
    (hδ_lt : δ < 1)
    (v_bar1 v1 : ℝ)
    (h_lower : v1 = v - δ * v_bar1)
    (h_upper : v_bar1 ≤ v - δ * v1)
    (h_lower_bound : v1 ≤ v_bar1) :
    v_bar1 = v / (1 + δ) ∧ v1 = v / (1 + δ) ∧
    v - v / (1 + δ) = δ * v / (1 + δ) := by
  have hδ1_pos : (0 : ℝ) < 1 + δ := by linarith
  have hδ1_ne : (1 : ℝ) + δ ≠ 0 := ne_of_gt hδ1_pos
  -- From h_upper and h_lower: v_bar1 ≤ v - δ*(v - δ*v_bar1) = v - δ*v + δ²*v_bar1
  -- So v_bar1*(1 - δ²) ≤ v*(1 - δ), i.e. v_bar1*(1+δ) ≤ v
  have hub : v_bar1 * (1 + δ) ≤ v := by nlinarith [sq_nonneg δ]
  -- From h_lower_bound: v - δ*v_bar1 ≤ v_bar1, so v ≤ v_bar1*(1+δ)
  have hlb : v ≤ v_bar1 * (1 + δ) := by nlinarith
  -- So v_bar1*(1+δ) = v
  have heq : v_bar1 * (1 + δ) = v := le_antisymm hub hlb
  have h3 : v_bar1 = v / (1 + δ) := by
    field_simp
    linarith
  have h4 : v1 = v / (1 + δ) := by
    rw [h_lower, h3]
    field_simp
    ring
  exact ⟨h3, h4, by field_simp; ring⟩