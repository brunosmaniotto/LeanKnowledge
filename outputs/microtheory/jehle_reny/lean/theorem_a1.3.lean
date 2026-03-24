import Mathlib

open Metric Set
open Topology

theorem theorem_A1_3 {n : ℕ} (S : Set (EuclideanSpace ℝ (Fin n))) (hS : IsOpen S)
    (ε : EuclideanSpace ℝ (Fin n) → ℝ)
    (hε_pos : ∀ x ∈ S, 0 < ε x)
    (hε_sub : ∀ x ∈ S, Metric.ball x (ε x) ⊆ S) :
    S = ⋃ x ∈ S, Metric.ball x (ε x) := by
  ext y
  simp only [mem_iUnion]
  constructor
  · intro hy
    exact ⟨y, hy, mem_ball_self (hε_pos y hy)⟩
  · rintro ⟨x, hx, hy_ball⟩
    exact hε_sub x hx hy_ball