import Mathlib

open BigOperators Finset
open Topology

theorem quasilinear_ups_ordering
    {n : ℕ} (c₁ c₂ : ℝ)
    (U  : Set (Fin n → ℝ)) (U' : Set (Fin n → ℝ))
    (hU  : U  = {u | ∑ i, u i ≤ c₁})
    (hU' : U' = {u | ∑ i, u i ≤ c₂}) :
    U ⊆ U' ∨ U' ⊆ U := by
  rcases le_total c₁ c₂ with h | h
  · left
    intro u hu
    rw [hU] at hu; rw [hU']
    simp only [Set.mem_setOf_eq] at *
    linarith
  · right
    intro u hu
    rw [hU'] at hu; rw [hU]
    simp only [Set.mem_setOf_eq] at *
    linarith