import Mathlib

open Set
open Topology

/-- Quasiconcavity (convex upper contour sets) is preserved under increasing transformations. -/
theorem quasiconcavity_preserved_under_increasing_transform
    {E : Type*} [AddCommMonoid E] [Module ℝ E]
    (s : Set E) (f : E → ℝ) (g : ℝ → ℝ)
    (hg : StrictMono g)
    (hf : ∀ c : ℝ, Convex ℝ {x ∈ s | c ≤ f x}) :
    ∀ c : ℝ, Convex ℝ {x ∈ s | c ≤ g (f x)} := by
  intro c x hx y hy a b ha hb hab
  simp only [mem_sep_iff] at hx hy ⊢
  obtain ⟨hxs, hcgfx⟩ := hx
  obtain ⟨hys, hcgfy⟩ := hy
  set d := min (f x) (f y)
  have hxd : x ∈ {z ∈ s | d ≤ f z} := ⟨hxs, min_le_left _ _⟩
  have hyd : y ∈ {z ∈ s | d ≤ f z} := ⟨hys, min_le_right _ _⟩
  have hmem := hf d hxd hyd ha hb hab
  simp only [mem_sep_iff] at hmem
  obtain ⟨hms, hdfm⟩ := hmem
  refine ⟨hms, ?_⟩
  have hcd : c ≤ g d := by
    rcases le_total (f x) (f y) with h | h
    · have : d = f x := min_eq_left h
      rw [this]; exact hcgfx
    · have : d = f y := min_eq_right h
      rw [this]; exact hcgfy
  exact le_trans hcd (hg.monotone hdfm)