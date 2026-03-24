import Mathlib

theorem Claim_5B_d {V : Type*} [AddCommGroup V] [Module ℝ V]
    (Y : Set V) (hconv : Convex ℝ Y) (h0 : (0 : V) ∈ Y)
    (y : V) (hy : y ∈ Y) (α : ℝ) (hα0 : 0 ≤ α) (hα1 : α ≤ 1) :
    α • y ∈ Y := by
  have h1 : (1 - α) ≥ 0 := by linarith
  have := hconv hy h0 hα0 h1 (by ring : α + (1 - α) = 1)
  simp at this
  exact this