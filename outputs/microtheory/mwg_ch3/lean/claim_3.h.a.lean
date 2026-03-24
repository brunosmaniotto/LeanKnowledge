import Mathlib
open Topology

variable (n : ℕ)

def IsHomogZero (x : (Fin n → ℝ) → ℝ → (Fin n → ℝ)) : Prop :=
  ∀ (p : Fin n → ℝ) (w : ℝ) (t : ℝ), t > 0 → x (fun i => t * p i) (t * w) = x p w