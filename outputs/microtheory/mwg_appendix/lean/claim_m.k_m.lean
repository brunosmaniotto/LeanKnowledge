import Mathlib
open Topology

noncomputable section

namespace MWG

-- Constraint optimization setup
variable {n k : ℕ}

def FeasibleAll (h : Fin k → (Fin n → ℝ) → ℝ) (c : Fin k → ℝ) : Set (Fin n → ℝ) :=
  {x | ∀ i, h i x ≤ c i}