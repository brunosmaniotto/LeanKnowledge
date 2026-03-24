import Mathlib

theorem indirect_proof (P : Prop) : (¬ P → False) → P := by
  exact by_contradiction