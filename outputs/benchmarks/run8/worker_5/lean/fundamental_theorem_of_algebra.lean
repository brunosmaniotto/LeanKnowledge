import Mathlib

open Polynomial

theorem fundamental_theorem_of_algebra (p : ℂ[X]) (h : p.natDegree ≠ 0) : ∃ z : ℂ, p.eval z = 0 := by
  have h0 : 0 < p.natDegree := Nat.pos_of_ne_zero h
  have hdeg : 0 < degree p := natDegree_pos_iff_degree_pos.mp h0
  exact Complex.exists_root hdeg