import Mathlib

/-- Proposition 20.E.1 (algebraic core):
    In the smooth case, profit maximization at every period forces the price scalars
    λ_t to satisfy λ_{t+1} = α·λ_t for a fixed α > 0. This theorem captures that
    algebraic fact: any sequence satisfying such a recurrence is geometric with ratio α,
    establishing the myopically profit-maximizing price path p_t = α^t · p_0. -/
theorem Proposition_20E1
    (p : ℕ → ℝ) (α : ℝ)
    (hα : 0 < α)
    (hp0 : 0 < p 0)
    (h_recur : ∀ t : ℕ, p (t + 1) = α * p t) :
    ∃ p_0 : ℝ, 0 < p_0 ∧ ∀ t : ℕ, p t = α ^ t * p_0 := by
  refine ⟨p 0, hp0, ?_⟩
  intro t
  induction t with
  | zero => simp
  | succ n ih =>
    rw [h_recur n]
    linear_combination α * ih