import Mathlib

open Set

theorem claim_A1_4_2_a {V : Type*} [AddCommMonoid V] [Module ℝ V]
    (D : Set V) (hD : Convex ℝ D)
    (x1 x2 : V) (hx1 : x1 ∈ D) (hx2 : x2 ∈ D)
    (t : ℝ) (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    t • x1 + (1 - t) • x2 ∈ D := by
  exact hD hx1 hx2 ht0 (sub_nonneg.mpr ht1) (by ring)