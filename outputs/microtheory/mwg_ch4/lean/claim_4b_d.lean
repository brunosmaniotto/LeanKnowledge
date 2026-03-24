import Mathlib
open Topology

def IsHomothetic {L : ℕ} (d : (Fin L → ℝ) → ℝ → (Fin L → ℝ)) : Prop :=
  ∀ (p : Fin L → ℝ) (w : ℝ) (α : ℝ), 0 < α → 0 < w →
    d p (α * w) = fun l => α * d p w l