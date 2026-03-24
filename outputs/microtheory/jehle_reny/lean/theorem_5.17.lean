import Mathlib

open BigOperators Finset
open Topology

theorem Theorem_5_17
    {I : ℕ}
    {X : Type*}
    (u : Fin I → X → ℝ)
    (x e : Fin I → X)
    (p : X → ℝ)
    (hfeas : ∑ i : Fin I, p (x i) = ∑ i : Fin I, p (e i))
    (hP4 : ∀ i : Fin I, p (x i) ≥ p (e i))
    (hFOC : ∀ i : Fin I, p (x i) = p (e i) →
            ∀ y : X, p y ≤ p (e i) → u i y ≤ u i (x i)) :
    ∀ i : Fin I, ∀ y : X, p y ≤ p (e i) → u i y ≤ u i (x i) := by
  intro i
  apply hFOC
  apply le_antisymm
  · by_contra h
    push_neg at h
    have := sum_lt_sum (fun j _ => hP4 j) ⟨i, mem_univ i, h⟩
    linarith
  · exact hP4 i