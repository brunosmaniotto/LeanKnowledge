import Mathlib

open Set Function Filter Topology

variables {p : ℝ → ℝ} {C : ℝ → ℝ} {q₀ : ℝ}

-- Assumptions on differentiability of p and C, implying continuity
variable (hp_diff : Differentiable ℝ p)
variable (hC_diff : Differentiable ℝ C)
-- Assumption that q₀ is non-negative, ensuring [0, q₀] is a valid interval
variable (hq₀_nonneg : 0 ≤ q₀)

-- Profit function definition: π(q) = p(q) * q - C(q)
def profit (q : ℝ) : ℝ := p q * q - C q

-- Lemma: Profit function is continuous on ℝ