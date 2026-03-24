import Mathlib

noncomputable def offerCurve
    {L : ℕ}
    (demand : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (p_bar : Fin L → ℝ)
    (w : ℝ)
    (k : Fin L) :
    Set (Fin L → ℝ) :=
  { x : Fin L → ℝ | ∃ p_k : ℝ, x = demand (Function.update p_bar k p_k) w }