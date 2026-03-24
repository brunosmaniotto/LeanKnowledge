import Mathlib

def MonotonePref (pref : ℝ × ℝ → ℝ × ℝ → Prop) : Prop :=
  ∀ x y, x.1 < y.1 → x.2 < y.2 → pref x y