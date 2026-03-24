import Mathlib

open scoped BigOperators
open Topology

theorem claim_2_4_3_geometric
    {u : ℝ → ℝ} {s : Set ℝ} (hs : Convex ℝ s)
    (hsc : StrictConcaveOn ℝ s u)
    {w₁ w₂ : ℝ} (hw₁ : w₁ ∈ s) (hw₂ : w₂ ∈ s) (hne : w₁ ≠ w₂)
    {p : ℝ} (hp0 : 0 < p) (hp1 : p < 1) :
    u (p * w₁ + (1 - p) * w₂) > p * u w₁ + (1 - p) * u w₂ := by
  have hp0' : 0 < 1 - p := by linarith
  have hsum : p + (1 - p) = 1 := by ring
  exact hsc.2 hw₁ hw₂ hne hp0 hp0' hsum