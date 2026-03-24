import Mathlib
open Topology

noncomputable def backwardShift (x : ℕ → ℝ) : ℕ → ℝ := fun t => x (t + 1)

theorem backwardShift_surjective : Function.Surjective backwardShift := by
  intro y
  exact ⟨fun n => if n = 0 then 0 else y (n - 1), by ext t; simp [backwardShift]⟩