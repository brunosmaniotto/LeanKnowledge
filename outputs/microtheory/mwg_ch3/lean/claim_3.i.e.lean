import Mathlib
open Topology

theorem ev_preserves_ranking (e₁ e₂ w : ℝ) :
    (e₁ - w) ≥ (e₂ - w) ↔ e₁ ≥ e₂ := by
  constructor <;> intro h <;> linarith