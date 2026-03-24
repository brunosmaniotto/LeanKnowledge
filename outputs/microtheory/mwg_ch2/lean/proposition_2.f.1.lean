import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {L : ℕ} [NeZero L]

noncomputable def dot (p x : Fin L → ℝ) : ℝ := ∑ i, p i * x i

structure WDemand (L : ℕ) where
  x : (Fin L → ℝ) → ℝ → (Fin L → ℝ)

variable (d : WDemand L)

def WalrasLaw : Prop :=
  ∀ p w, dot p (d.x p w) = w