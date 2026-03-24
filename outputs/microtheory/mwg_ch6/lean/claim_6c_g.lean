import Mathlib
open Topology

/-- For a risk averter (concave utility), Jensen's inequality gives non-negative risk premium. -/
theorem risk_premium_nonneg
    {u : ℝ → ℝ} (hu : ConcaveOn ℝ Set.univ u)
    (x ε : ℝ) (hε : ε > 0)
    (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    : p * u (x + ε) + (1 - p) * u (x - ε) ≤ u (p * (x + ε) + (1 - p) * (x - ε)) := by
  have h1p : 0 ≤ 1 - p := by linarith
  have hab : p + (1 - p) = 1 := by ring
  exact hu.2 (Set.mem_univ _) (Set.mem_univ _) hp0 h1p hab