import Mathlib

open Metric

theorem limit_unique_metric_on_subset {X Y : Type*} [MetricSpace X] [MetricSpace Y] {S : Set X}
    {f : S → Y} {x₀ : X} (hx₀ : ∀ δ > 0, ∃ x ∈ S, x ≠ x₀ ∧ dist x x₀ < δ) {L L' : Y}
    (hL : ∀ ε > 0, ∃ δ > 0, ∀ x : S, (x : X) ≠ x₀ → dist (x : X) x₀ < δ → dist (f x) L < ε)
    (hL' : ∀ ε > 0, ∃ δ > 0, ∀ x : S, (x : X) ≠ x₀ → dist (x : X) x₀ < δ → dist (f x) L' < ε) :
    L = L' := by
  by_contra h
  have hpos : 0 < dist L L' := dist_pos.mpr h
  set ε := dist L L' / 2 with hε_def
  have hε : 0 < ε := by linarith
  rcases hL ε hε with ⟨δ₁, hδ₁, hL₁⟩
  rcases hL' ε hε with ⟨δ₂, hδ₂, hL₂⟩
  set δ := min δ₁ δ₂ with hδ_def
  have hδ : 0 < δ := by
    exact lt_min_iff.mpr ⟨hδ₁, hδ₂⟩
  rcases hx₀ δ hδ with ⟨x, hxS, hx_ne, hx_dist⟩
  have hx_dist' : dist x x₀ < δ₁ ∧ dist x x₀ < δ₂ := by
    exact lt_min_iff.mp hx_dist
  let x' : S := ⟨x, hxS⟩
  have h1 : dist (f x') L < ε := hL₁ x' hx_ne hx_dist'.left
  have h2 : dist (f x') L' < ε := hL₂ x' hx_ne hx_dist'.right
  have htri : dist L L' ≤ dist L (f x') + dist (f x') L' := dist_triangle L (f x') L'
  have : dist L L' < dist L L' := by
    calc
      dist L L' ≤ dist L (f x') + dist (f x') L' := htri
      _ = dist (f x') L + dist (f x') L' := by rw [dist_comm L (f x')]
      _ < ε + ε := by linarith
      _ = dist L L' := by rw [hε_def]; ring
  linarith