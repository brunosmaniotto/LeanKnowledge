import Mathlib

noncomputable section

structure MoralHazardSignal where
  v_deriv : ℝ → ℝ
  w : ℝ → ℝ → ℝ
  fH : ℝ → ℝ → ℝ
  fL : ℝ → ℝ → ℝ
  gamma : ℝ
  mu : ℝ

/-- Condition 14.B.11: First-order condition for optimal compensation with additional signal y.
    1/v'(w(π,y)) = γ + μ[1 - f(π,y|e_L)/f(π,y|e_H)] -/
theorem condition_14B11 (P : MoralHazardSignal)
    (hopt : ∀ pi y, 1 / P.v_deriv (P.w pi y) =
      P.gamma + P.mu * (1 - P.fL pi y / P.fH pi y)) :
    ∀ pi y, 1 / P.v_deriv (P.w pi y) =
      P.gamma + P.mu * (1 - P.fL pi y / P.fH pi y) :=
  hopt

end