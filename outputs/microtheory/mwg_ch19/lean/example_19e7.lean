import Mathlib

open Matrix
open Topology

theorem Example_19E7
    (q_b q_c : ℝ)
    (hne : q_b ≠ q_c) :
    let R_a : Matrix (Fin 2) (Fin 2) ℝ := !![1, 1; q_b, q_c]
    let R_b : Matrix (Fin 2) (Fin 2) ℝ := !![1, 1; 0, 1]
    let R_c : Matrix (Fin 2) (Fin 2) ℝ := !![1, 1; 0, 1]
    R_a.det ≠ 0 ∧ R_b.det ≠ 0 ∧ R_c.det ≠ 0 := by
  refine ⟨?_, ?_, ?_⟩
  · simp [det_fin_two]
    intro h
    apply hne
    linarith
  · simp [det_fin_two]
  · simp [det_fin_two]