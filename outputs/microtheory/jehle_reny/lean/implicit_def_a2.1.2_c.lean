import Mathlib
open Topology

noncomputable section
variable {n : ℕ}

def MWG.PartialDeriv (f : (Fin n → ℝ) → ℝ) (i : Fin n) (x : Fin n → ℝ) : ℝ :=
  deriv (fun t => f (Function.update x i t)) (x i)