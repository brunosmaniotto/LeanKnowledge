import Mathlib

open Finset BigOperators
open Topology

def IsAnonymous {n : ℕ} (W : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ (σ : Equiv.Perm (Fin n)) (u : Fin n → ℝ), W (u ∘ σ) = W u