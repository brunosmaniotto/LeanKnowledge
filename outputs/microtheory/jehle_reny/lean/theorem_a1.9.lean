import Mathlib

open Filter Topology
open Topology

-- Part 2: D is closed iff sequentially closed
theorem theorem_A1_9_part2 {n : ℕ} (D : Set (EuclideanSpace ℝ (Fin n))) :
    IsClosed D ↔
    (∀ (seq : ℕ → EuclideanSpace ℝ (Fin n)) (x : EuclideanSpace ℝ (Fin n)),
      (∀ k, seq k ∈ D) → Tendsto seq atTop (𝓝 x) → x ∈ D) := by
  rw [← isSeqClosed_iff_isClosed]
  constructor
  · intro h seq x hmem htend
    exact h hmem htend
  · intro h seq x hmem htend
    exact h seq x hmem htend

-- Part 3: f is continuous iff sequentially continuous