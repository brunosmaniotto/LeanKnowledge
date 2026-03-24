import Mathlib
set_option linter.unusedVariables false

private lemma folk_threshold_lt_one {m pt z : ℝ} (h1 : pt > z) (h2 : m ≥ pt) :
    (m - pt) / (m - z) < 1 := by
  have hmz : (0 : ℝ) < m - z := by linarith
  rw [div_lt_one hmz]
  linarith

private lemma folk_no_deviation {m pt z d : ℝ}
    (hd0 : 0 ≤ d) (h1 : pt > z) (h2 : m ≥ pt)
    (hd : (m - pt) / (m - z) < d) :
    (1 - d) * m + d * z ≤ pt := by
  have hmz : (0 : ℝ) < m - z := by linarith
  have step : m - pt < d * (m - z) := by
    have hmul := mul_lt_mul_of_pos_right hd hmz
    -- hmul : (m - pt) / (m - z) * (m - z) < d * (m - z)
    have heq : (m - pt) / (m - z) * (m - z) = m - pt := by
      field_simp [hmz.ne']
    linarith
  -- step : m - pt < d * (m - z)
  -- mul_sub d m z : d * (m - z) = d * m - d * z
  linarith [mul_sub d m z]

/-- The Folk Theorem (Proposition_12AA5):
    For any feasible individually rational payoff pair (pt1, pt2) with pt_i > z_i,
    and where m_i ≥ pt_i is the best deviation payoff, there exists delta_bar < 1
    such that for all delta > delta_bar the grim-trigger no-deviation conditions hold. -/
theorem Proposition_12AA5
    (m1 m2 pt1 pt2 z1 z2 : ℝ)
    (hir1 : pt1 > z1) (hir2 : pt2 > z2)
    (hm1  : m1 ≥ pt1) (hm2  : m2 ≥ pt2) :
    ∃ delta_bar : ℝ, delta_bar < 1 ∧
      ∀ d : ℝ, delta_bar < d → d < 1 → 0 ≤ d →
        (1 - d) * m1 + d * z1 ≤ pt1 ∧ (1 - d) * m2 + d * z2 ≤ pt2 := by
  refine ⟨max ((m1 - pt1) / (m1 - z1)) ((m2 - pt2) / (m2 - z2)), ?_, ?_⟩
  · simp only [max_lt_iff]
    exact ⟨folk_threshold_lt_one hir1 hm1, folk_threshold_lt_one hir2 hm2⟩
  · intro d hd _hd1 hd0
    constructor
    · apply folk_no_deviation hd0 hir1 hm1
      exact lt_of_le_of_lt (le_max_left _ _) hd
    · apply folk_no_deviation hd0 hir2 hm2
      exact lt_of_le_of_lt (le_max_right _ _) hd