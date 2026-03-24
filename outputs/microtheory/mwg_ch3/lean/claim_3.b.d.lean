import Mathlib

open Finset BigOperators

variable {L : ℕ} (hL : 0 < L)

def MonotonePref (pref : (Fin L → ℝ) → (Fin L → ℝ) → Prop) : Prop :=
  ∀ x y : Fin L → ℝ, (∀ i, x i ≤ y i) → (∃ i, x i < y i) → pref x y