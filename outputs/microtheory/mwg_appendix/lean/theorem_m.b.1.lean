import Mathlib

open scoped BigOperators
open Topology

variable {N : ℕ}

def IsHomogeneous (f : (Fin N → ℝ) → ℝ) (r : ℤ) : Prop :=
  ∀ (t : ℝ) (x : Fin N → ℝ), 0 < t → f (t • x) = (t : ℝ) ^ r * f x

noncomputable def partialDeriv (f : (Fin N → ℝ) → ℝ) (n : Fin N) (x : Fin N → ℝ) : ℝ :=
  deriv (fun s => f (Function.update x n (x n + s))) 0