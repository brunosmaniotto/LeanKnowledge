import Mathlib
open Topology

noncomputable section

variable {p₀ p₁ y₀ CV : ℝ}
variable (v : ℝ → ℝ → ℝ)

-- Assumptions about v:
-- v is non-increasing in price (p)
variable (hv_p_nonincreasing : ∀ (p_a p_b y : ℝ), p_a ≤ p_b → v p_a y ≥ v p_b y)
-- v is strictly increasing in income (y)
variable (hv_y_strict_increasing : ∀ (p y_a y_b : ℝ), y_a < y_b → v p y_a < v p y_b)
-- Definition of Compensating Variation (CV): v(p₁, y₀ + CV) = v(p₀, y₀)
variable (hCV_def : v p₁ (y₀ + CV) = v p₀ y₀)

/-- Helper lemma: if `v p y₁ ≤ v p y₂`, then `y₁ ≤ y₂` due to `v` being strictly increasing in `y`. -/
lemma le_of_v_le_v' (p_val : ℝ) {y₁ y₂ : ℝ}
    (hv_y_strict_increasing_local : ∀ (p_arg y_a y_b : ℝ), y_a < y_b → v p_arg y_a < v p_arg y_b)
    (h_le : v p_val y₁ ≤ v p_val y₂) : y₁ ≤ y₂ := by
  by_contra h_contra
  push_neg at h_contra -- h_contra is now y₂ < y₁
  have h_v_lt : v p_val y₂ < v p_val y₁ := hv_y_strict_increasing_local p_val y₂ y₁ h_contra
  exact lt_irrefl (v p_val y₂) (h_v_lt.trans_le h_le)