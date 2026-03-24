import Mathlib
open Topology

theorem utility_strictly_increasing_transform
    {X : Type*} (u : X → ℝ) (f : ℝ → ℝ) (hf : StrictMono f)
    (x y : X) : f (u x) ≥ f (u y) ↔ u x ≥ u y := by
  constructor
  · intro h
    by_contra h'
    push_neg at h'
    exact not_le.mpr (hf h') h
  · intro h
    rcases eq_or_lt_of_le h with heq | hlt
    · exact le_of_eq (congrArg f heq)
    · exact le_of_lt (hf hlt)