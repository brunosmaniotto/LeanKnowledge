import Mathlib

open Filter Topology

noncomputable section

/-- The sequence `n^(1/n)` for `n : ℕ`. We define it for all `n`, but note that for `n=0` we set it to 0. -/
def seq (n : ℕ) : ℝ := if n = 0 then 0 else (n : ℝ) ^ (1 / (n : ℝ))