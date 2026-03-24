import Mathlib
open Topology
open BigOperators

variable {L : ℕ}

def ConcaveU (u : (Fin L → ℝ) → ℝ) : Prop :=
  ∀ (n : ℕ) (x : Fin n → Fin L → ℝ) (p : Fin n → ℝ),
    (∀ i, 0 ≤ p i) → ∑ i, p i = 1 →
    u (∑ i, p i • x i) ≥ ∑ i, p i * u (x i)