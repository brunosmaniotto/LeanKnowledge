import Mathlib
open Topology

/-
Claim 15.D_g: Under factor intensity conditions, two unit cost curves
can cross at most once, so interior equilibrium factor prices are unique.

We formalize the core mathematical content: if two continuous functions
f, g : ℝ → ℝ have the property that (f - g) is strictly monotone,
then they can intersect at most once.
-/

theorem Claim_15D_g
    (c₁ c₂ : ℝ → ℝ)
    (h_strict_mono : StrictMono (fun w => c₁ w - c₂ w)) :
    Set.InjOn (fun _ => ()) {w | c₁ w = c₂ w} := by
  intro w₁ hw₁ w₂ hw₂ _
  simp [Set.mem_setOf_eq] at hw₁ hw₂
  by_contra h
  push_neg at h
  rcases ne_iff_lt_or_gt.mp h with hlt | hgt
  · have := h_strict_mono hlt
    simp [hw₁, hw₂] at this
  · have := h_strict_mono hgt
    simp [hw₁, hw₂] at this