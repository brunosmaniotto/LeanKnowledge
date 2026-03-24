import Mathlib
open Topology

theorem claim_A1_3_2_a (n : ℕ) (S : Set (EuclideanSpace ℝ (Fin n)))
    (g : EuclideanSpace ℝ (Fin n) → EuclideanSpace ℝ (Fin n))
    (f : EuclideanSpace ℝ (Fin n) → EuclideanSpace ℝ (Fin n))
    (hf : ∀ x, f x = g x + x)
    (x : EuclideanSpace ℝ (Fin n)) :
    g x = 0 ↔ f x = x := by
  constructor
  · intro hg
    rw [hf, hg, zero_add]
  · intro hfx
    rw [hf] at hfx
    have : g x + x - x = x - x := congrArg (· - x) hfx
    simp at this
    exact this