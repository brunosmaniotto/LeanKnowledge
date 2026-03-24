import Mathlib

open Set
open Topology

theorem claim_M_K_k {S : Set ℝ} {f : ℝ → ℝ} (hS : Convex ℝ S)
    (hqc : ∀ x ∈ S, ∀ y ∈ S, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      f (t * x + (1 - t) * y) ≥ min (f x) (f y))
    (M : Set ℝ) (hM : M = {x ∈ S | ∀ y ∈ S, f y ≤ f x}) :
    Convex ℝ M := by
  rw [hM]
  intro x hx y hy t s ht hs hts
  simp only [mem_setOf_eq] at hx hy ⊢
  obtain ⟨hxS, hxmax⟩ := hx
  obtain ⟨hyS, hymax⟩ := hy
  have hsub : s = 1 - t := by linarith
  subst hsub
  refine ⟨hS hxS hyS ht hs hts, fun z hz => ?_⟩
  have hfxy : f x = f y := le_antisymm (hymax x hxS) (hxmax y hyS)
  have hmix := hqc x hxS y hyS t ht (by linarith)
  calc f z ≤ f x := hxmax z hz
    _ = min (f x) (f y) := by rw [hfxy, min_self]
    _ ≤ f (t * x + (1 - t) * y) := hmix