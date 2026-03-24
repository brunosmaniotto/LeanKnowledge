import Mathlib
open SimpleGraph

-- The following lemma is assumed; in practice it should be proved or found in Mathlib.
theorem cycleGraph_degree_two (n : ℕ) (hn : 3 ≤ n) (v : Fin n) : (cycleGraph n).degree v = 2 := by
  sorry