import Mathlib

noncomputable def inducedProfitStream
    (y_b : ℕ → ℝ) (y_a : ℕ → ℝ) (p : ℕ → ℝ) (t : ℕ) : ℝ :=
  p t * y_b t + p (t + 1) * y_a t