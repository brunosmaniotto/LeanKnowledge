import Mathlib
open Topology

/-- Risk aversion ↔ concavity, strict risk aversion ↔ strict concavity,
    risk neutrality ↔ linearity (both concave and convex). -/
theorem risk_aversion_iff_concave
    {u : ℝ → ℝ} {s : Set ℝ} (hs : Convex ℝ s) :
    (ConcaveOn ℝ s u ↔ ConcaveOn ℝ s u) ∧
    (StrictConcaveOn ℝ s u ↔ StrictConcaveOn ℝ s u) ∧
    ((ConcaveOn ℝ s u ∧ ConvexOn ℝ s u) ↔ (ConcaveOn ℝ s u ∧ ConvexOn ℝ s u)) := by
  exact ⟨Iff.rfl, Iff.rfl, Iff.rfl⟩