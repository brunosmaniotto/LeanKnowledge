import Mathlib
open Topology
set_option linter.unusedVariables false

/-- Exercise 6.14(b): The Atkinson index I(y) = yₑ/μ is normatively significant.
    For distributions with the same mean μ > 0, I(y1) ≤ I(y2) iff W(y1) ≤ W(y2). -/
theorem Exercise_6_14_b
    {n : ℕ} [NeZero n]
    (W : (Fin n → ℝ) → ℝ)
    (ye : (Fin n → ℝ) → ℝ)
    (μ : ℝ) (hμ : 0 < μ)
    -- ye(y) is the equally distributed equivalent: W(fun _ => ye y) = W y
    (hye_welfare : ∀ y, W (fun _ => ye y) = W y)
    -- W is monotone on constant distributions
    (hW_mono : ∀ a b : ℝ, a ≤ b ↔ W (fun _ => a) ≤ W (fun _ => b))
    (y1 y2 : Fin n → ℝ) :
    ye y1 / μ ≤ ye y2 / μ ↔ W y1 ≤ W y2 := by
  have hμne : μ ≠ 0 := hμ.ne'
  constructor
  · intro h
    -- Multiply both sides by μ to eliminate division
    have h1 := mul_le_mul_of_nonneg_right h (le_of_lt hμ)
    have cancel1 : ye y1 / μ * μ = ye y1 := by field_simp
    have cancel2 : ye y2 / μ * μ = ye y2 := by field_simp
    have he : ye y1 ≤ ye y2 := by linarith
    -- Convert via hW_mono and hye_welfare
    have hw := (hW_mono (ye y1) (ye y2)).mp he
    rwa [hye_welfare y1, hye_welfare y2] at hw
  · intro h
    -- Convert W comparison to ye comparison
    have hw : W (fun _ => ye y1) ≤ W (fun _ => ye y2) := by
      rw [hye_welfare y1, hye_welfare y2]; exact h
    have he := (hW_mono (ye y1) (ye y2)).mpr hw
    -- Convert division to multiplication by μ⁻¹, then use monotonicity
    simp only [div_eq_mul_inv]
    exact mul_le_mul_of_nonneg_right he (inv_pos.mpr hμ).le