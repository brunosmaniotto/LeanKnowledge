import Mathlib

/-- Insurance expected utility functions u_l(B,p) = p·u(B/p) + (1-p)·u(0) and
    u_h(B,p) = p·u(0) + (1-p)·u(B/(1-p)) are strictly increasing in B
    when u is strictly increasing and p ∈ (0,1). -/
theorem Claim_8_1_2_b
    (u : ℝ → ℝ)
    (hu_strict_mono : StrictMono u) :
    -- u_l is strictly increasing in B for fixed p ∈ (0,1)
    (∀ (p : ℝ), 0 < p → p < 1 →
      ∀ B₁ B₂ : ℝ, B₁ < B₂ →
        p * u (B₁ / p) + (1 - p) * u 0 < p * u (B₂ / p) + (1 - p) * u 0) ∧
    -- u_h is strictly increasing in B for fixed p ∈ (0,1)
    (∀ (p : ℝ), 0 < p → p < 1 →
      ∀ B₁ B₂ : ℝ, B₁ < B₂ →
        p * u 0 + (1 - p) * u (B₁ / (1 - p)) < p * u 0 + (1 - p) * u (B₂ / (1 - p))) := by
  constructor
  · intro p hp _ B₁ B₂ hB
    have hpinv : 0 < p⁻¹ := inv_pos.mpr hp
    have hdiv : B₁ / p < B₂ / p := by
      simp only [div_eq_mul_inv]
      exact mul_lt_mul_of_pos_right hB hpinv
    have h1 : u (B₁ / p) < u (B₂ / p) := hu_strict_mono hdiv
    linarith [mul_lt_mul_of_pos_left h1 hp]
  · intro p hp hp1 B₁ B₂ hB
    have h1mp : (0 : ℝ) < 1 - p := by linarith
    have hpinv : 0 < (1 - p)⁻¹ := inv_pos.mpr h1mp
    have hdiv : B₁ / (1 - p) < B₂ / (1 - p) := by
      simp only [div_eq_mul_inv]
      exact mul_lt_mul_of_pos_right hB hpinv
    have h1 : u (B₁ / (1 - p)) < u (B₂ / (1 - p)) := hu_strict_mono hdiv
    linarith [mul_lt_mul_of_pos_left h1 h1mp]