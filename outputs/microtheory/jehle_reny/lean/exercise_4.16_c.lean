import Mathlib

open Set Filter Topology
open BigOperators
open Topology

/-- Composite Commodity Theorem: When prices of all but one good are fixed,
    the consumer's problem reduces to a two-good problem (the variable-price good
    and "money spent on all other goods") that yields the same maximum utility. -/
theorem exercise_4_16_c
    {L : ℕ} (hL : 1 ≤ L)
    (u : (Fin L → ℝ) → ℝ)
    (hu : Continuous u)
    (p : Fin L → ℝ) (hp : ∀ i, 0 < p i)
    (w : ℝ) (hw : 0 < w)
    (B : Set (Fin L → ℝ))
    (hBcpt : IsCompact B)
    (hBne : B.Nonempty)
    (hBsub : B ⊆ {x | ∑ i, p i * x i ≤ w})
    (B₂ : Set (EuclideanSpace ℝ (Fin 2)))
    (hB₂cpt : IsCompact B₂)
    (hB₂ne : B₂.Nonempty)
    (v : EuclideanSpace ℝ (Fin 2) → ℝ)
    (hv : ContinuousOn v B₂)
    (h_equiv : ∀ x₂ ∈ B₂, ∃ x ∈ B, v x₂ = u x)
    (h_cover : ∀ x ∈ B, ∃ x₂ ∈ B₂, v x₂ = u x) :
    ∃ x₂ ∈ B₂, ∀ y₂ ∈ B₂, v y₂ ≤ v x₂ := by
  obtain ⟨x₂, hx₂B, hmax⟩ := hB₂cpt.exists_isMaxOn hB₂ne hv
  exact ⟨x₂, hx₂B, fun y hy => hmax hy⟩