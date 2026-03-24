import Mathlib

open Set
open Topology

/-- The hypograph of a concave function on a convex domain is a convex set. -/
theorem hypograph_convex_of_concave {D : Set ℝ} (hD : Convex ℝ D)
    {f : ℝ → ℝ} (hf : ConcaveOn ℝ D f) :
    Convex ℝ {p : ℝ × ℝ | p.1 ∈ D ∧ p.2 ≤ f p.1} := by
  intro p hp q hq t s ht hs hts
  simp only [mem_setOf_eq] at hp hq ⊢
  constructor
  · exact hD hp.1 hq.1 ht hs hts
  · calc t • p.2 + s • q.2
        ≤ t • f p.1 + s • f q.1 := by
          apply add_le_add
          · exact smul_le_smul_of_nonneg_left hp.2 ht
          · exact smul_le_smul_of_nonneg_left hq.2 hs
      _ ≤ f (t • p.1 + s • q.1) := hf.2 hp.1 hq.1 ht hs hts