import Mathlib

open Finset BigOperators
open BigOperators

variable {L : ℕ}

/-- The technology set Y* = {y ∈ ℝ^L : p · y ≤ 0 ∧ p' · y ≤ 0} -/
def YStar (p p' : Fin L → ℝ) : Set (Fin L → ℝ) :=
  {y | ∑ i, p i * y i ≤ 0 ∧ ∑ i, p' i * y i ≤ 0}

/-- An equilibrium price for technology Y: z(price) ∈ Y and p · y ≤ 0 for all y ∈ Y -/
structure IsEquilibrium (price : Fin L → ℝ) (z : Fin L → ℝ) (Y : Set (Fin L → ℝ)) : Prop where
  excess_demand_in_Y : z ∈ Y
  profit_max : ∀ y ∈ Y, ∑ i, price i * y i ≤ 0

/-- WA violation conditions -/
structure WAViolation (p p' : Fin L → ℝ) (zp zp' : Fin L → ℝ) : Prop where
  walras_p : ∑ i, p i * zp i = 0
  walras_p' : ∑ i, p' i * zp' i = 0
  cross_p'_zp : ∑ i, p' i * zp i ≤ 0
  cross_p_zp' : ∑ i, p i * zp' i ≤ 0
  demands_ne : zp ≠ zp'