import Mathlib
open Topology

structure ConvexPreference (V : Type*) [AddCommGroup V] [Module ℝ V] where
  pref : V → V → Prop
  pref_refl : ∀ x, pref x x
  convex : ∀ (x y z : V) (t : ℝ), 0 ≤ t → t ≤ 1 → pref x z → pref y z →
    pref (t • x + (1 - t) • y) z

theorem mixture_not_worse {V : Type*} [AddCommGroup V] [Module ℝ V]
    (cp : ConvexPreference V) (x y : V)
    (hxy : cp.pref x y) (hyx : cp.pref y x) :
    cp.pref ((1/2 : ℝ) • x + (1/2 : ℝ) • y) y ∧
    cp.pref ((1/2 : ℝ) • x + (1/2 : ℝ) • y) x := by
  constructor
  · have h := cp.convex x y y (1/2 : ℝ) (by norm_num) (by norm_num) hxy (cp.pref_refl y)
    convert h using 2
    ring
  · have h := cp.convex x y x (1/2 : ℝ) (by norm_num) (by norm_num) (cp.pref_refl x) hyx
    convert h using 2
    ring