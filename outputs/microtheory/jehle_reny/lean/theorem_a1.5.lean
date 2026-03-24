import Mathlib

open Set Metric

-- Part 1a: inf of a bounded open set is not in the set
theorem inf_not_mem_open {S : Set ℝ} (hS : IsOpen S) (hne : S.Nonempty)
    (hbdd : BddBelow S) :
    sInf S ∉ S := by
  intro hmem
  obtain ⟨ε, hε, hball⟩ := Metric.isOpen_iff.mp hS (sInf S) hmem
  have hmem' : sInf S - ε / 2 ∈ S := by
    apply hball
    rw [Metric.mem_ball, Real.dist_eq]
    rw [abs_lt]
    constructor <;> linarith
  have : sInf S ≤ sInf S - ε / 2 := csInf_le hbdd hmem'
  linarith

-- Part 1b: sup of a bounded open set is not in the set