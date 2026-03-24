import Mathlib
open Topology

/-- In the symmetric information problem, because λ > 0, complementary slackness
    implies the participation constraint holds with equality:
    u(w − p − l + B_l) = d(e) + ū for all l ≥ 0. -/
theorem claim_8_constraint_binding_sym
    (u : ℝ → ℝ) (d : ℝ → ℝ)
    (w p e ū : ℝ)
    (B : ℝ → ℝ)
    (lam : ℝ)
    (hlam_pos : 0 < lam)
    (h_cs : ∀ l : ℝ, 0 ≤ l → lam * (u (w - p - l + B l) - (d e + ū)) = 0) :
    ∀ l : ℝ, 0 ≤ l → u (w - p - l + B l) = d e + ū := by
  intro l hl
  have h := h_cs l hl
  have hlam_ne : lam ≠ 0 := ne_of_gt hlam_pos
  cases mul_eq_zero.mp h with
  | inl h => exact absurd h hlam_ne
  | inr h => linarith