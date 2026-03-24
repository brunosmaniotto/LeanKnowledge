import Mathlib
open Topology

theorem majority_voting_TU_core_empty (u₁ u₂ u₃ : ℝ)
    (hsum : u₁ + u₂ + u₃ = 3) :
    u₁ + u₂ < 3 ∨ u₂ + u₃ < 3 ∨ u₁ + u₃ < 3 := by
  by_contra h
  push_neg at h
  obtain ⟨h12, h23, h13⟩ := h
  linarith