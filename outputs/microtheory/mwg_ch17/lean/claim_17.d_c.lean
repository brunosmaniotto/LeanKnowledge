import Mathlib

open BigOperators
open Topology

theorem existence_of_equilibrium
    {S : Type*} [DecidableEq S] [Fintype S]
    (index : S → ℤ)
    (h_sum : ∑ s : S, index s = 1) :
    Nonempty S := by
  by_contra h
  rw [not_nonempty_iff] at h
  simp [Fintype.sum_empty] at h_sum