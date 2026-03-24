import Mathlib

/-- Leontief preferences on ℝ²₊: x ≿ y iff min(x₁, x₂) ≥ min(y₁, y₂). -/
def leontiefPref (x y : ℝ × ℝ) : Prop :=
  min x.1 x.2 ≥ min y.1 y.2