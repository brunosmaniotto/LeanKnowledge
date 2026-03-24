import Mathlib

theorem claim_A2_5_c {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (C : Set E) (hC : Convex ℝ C) : Convex ℝ (closure C) :=
  hC.closure