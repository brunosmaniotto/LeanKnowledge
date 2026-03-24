import Mathlib
open Topology

noncomputable section

def IsLinHom (n : ℕ) (f : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ t > 0, ∀ x : Fin n → ℝ, f (t • x) = t * f x