import Mathlib
open Topology

theorem claim_A1_3_p {n : ℕ} (g : Fin n → (Fin n → ℝ) → ℝ) (x : Fin n → ℝ) :
    (∀ i, g i x = 0) ↔ (fun i => g i x + x i) = x := by
  constructor
  · intro h
    funext i
    simp [h i]
  · intro h
    intro i
    have := congr_fun h i
    simp at this
    linarith