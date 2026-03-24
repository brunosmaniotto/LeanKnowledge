import Mathlib

theorem complex_addition_closed (z w : ℂ) : z + w ∈ (Set.univ : Set ℂ) :=
  Set.mem_univ (z + w)