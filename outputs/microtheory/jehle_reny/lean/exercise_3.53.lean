import Mathlib
open Matrix Finset BigOperators Topology
open Topology

variable {n : ℕ} [NeZero n]

def IsHomogDegZero_inputs (x : Fin n → (Fin n → ℝ) → ℝ → ℝ) (y : (Fin n → ℝ) → ℝ → ℝ) : Prop :=
  ∀ (p : Fin n → ℝ) (w : ℝ) (t : ℝ), t > 0 →
    (∀ i, x i (fun j => t * p j) (t * w) = x i p w) ∧
    y (fun j => t * p j) (t * w) = y p w