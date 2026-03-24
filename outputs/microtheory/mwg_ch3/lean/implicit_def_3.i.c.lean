import Mathlib

/-- The compensating variation of a price change from p⁰ to p¹ at wealth w.
    CV(p⁰, p¹, w) = w − e(p¹, u⁰), where u⁰ = v(p⁰, w) is the original utility level
    and e is the expenditure function. -/
noncomputable def compensatingVariation
    {L : Type*} [Fintype L]
    (e : (L → ℝ) → ℝ → ℝ)
    (v : (L → ℝ) → ℝ → ℝ)
    (p0 p1 : L → ℝ)
    (w : ℝ) : ℝ :=
  w - e p1 (v p0 w)