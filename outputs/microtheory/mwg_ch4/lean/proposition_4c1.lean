import Mathlib

open Finset BigOperators
open BigOperators

def SatisfiesULD {L : Type*} [Fintype L]
    (x : (L → ℝ) → ℝ → (L → ℝ)) : Prop :=
  ∀ (p p' : L → ℝ) (w : ℝ),
    x p w ≠ x p' w →
    ∑ l : L, (p' l - p l) * (x p w l - x p' w l) < 0