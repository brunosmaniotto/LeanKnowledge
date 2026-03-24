import Mathlib
open Topology

theorem quasiconcave_iff_ordered {S : Set ℝ} {f : ℝ → ℝ} :
    (∀ x ∈ S, ∀ y ∈ S, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      f (t * x + (1 - t) * y) ≥ min (f x) (f y)) ↔
    (∀ x ∈ S, ∀ y ∈ S, f x ≥ f y → ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      f (t * x + (1 - t) * y) ≥ f y) := by
  constructor
  · intro h x hx y hy hge t ht0 ht1
    have := h x hx y hy t ht0 ht1
    simp [min_def] at this
    split_ifs at this with h1 <;> linarith
  · intro h x hx y hy t ht0 ht1
    rcases le_total (f x) (f y) with hle | hge
    · have key := h y hy x hx hle (1 - t) (by linarith) (by linarith)
      have : (1 - t) * y + (1 - (1 - t)) * x = t * x + (1 - t) * y := by ring
      rw [this] at key
      simp [min_def, hle]; linarith
    · have key := h x hx y hy hge t ht0 ht1
      simp [min_def]; split_ifs with h1 <;> linarith