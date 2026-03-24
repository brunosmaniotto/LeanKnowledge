import Mathlib
open Topology

theorem expected_utility_cardinal_property (u₁ u₂ u₃ u₄ : ℝ) :
    u₁ - u₂ > u₃ - u₄ ↔ (1/2) * u₁ + (1/2) * u₄ > (1/2) * u₂ + (1/2) * u₃ := by
  constructor <;> intro h <;> linarith