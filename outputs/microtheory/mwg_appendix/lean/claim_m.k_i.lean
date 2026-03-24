import Mathlib

open Set
open Topology

theorem constraint_set_convex_of_quasiconvex
    {n : ℕ} {k : ℕ}
    (h : Fin k → (Fin n → ℝ) → ℝ)
    (hqc : ∀ i, QuasiconvexOn ℝ univ (h i)) :
    Convex ℝ {x : Fin n → ℝ | ∀ i, h i x ≤ 0} := by
  have : {x : Fin n → ℝ | ∀ i, h i x ≤ 0} = ⋂ i, {x | h i x ≤ 0} := by
    ext x; simp [mem_iInter]
  rw [this]
  apply convex_iInter
  intro i
  have hi := hqc i 0
  convert hi using 1
  ext x
  simp [mem_univ]