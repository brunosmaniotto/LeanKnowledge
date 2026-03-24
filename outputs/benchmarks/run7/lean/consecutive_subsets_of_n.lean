import Mathlib

theorem range_eq_range_succ_diff_last (k : ℕ) : Finset.range k = (Finset.range (k + 1)) \ {k} := by
  ext x
  simp only [Finset.mem_range, Finset.mem_sdiff, Finset.mem_singleton]
  omega