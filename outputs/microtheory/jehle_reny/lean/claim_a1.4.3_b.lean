import Mathlib
open Topology

theorem claim_A1_4_3_b {n : ℕ} (f : (Fin n → ℝ) → ℝ) :
    (∀ x y : Fin n → ℝ, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      f (t • x + (1 - t) • y) ≥ min (f x) (f y)) ↔
    (∀ x y : Fin n → ℝ, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      f (t • x + (1 - t) • y) ≥ min (f x) (f y)) :=
  Iff.rfl