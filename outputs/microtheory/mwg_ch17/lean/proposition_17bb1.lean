import Mathlib
open BigOperators

-- Economic primitives
variable {I J : Type*} [Fintype I] [Fintype J] [DecidableEq I] [DecidableEq J]
variable {L : ℕ} -- number of commodities

-- Consumption set, preferences, endowments, shares, prices
variable (X : I → Set (Fin L → ℝ))
variable (pref : I → (Fin L → ℝ) → (Fin L → ℝ) → Prop)
variable (ω : I → Fin L → ℝ)
variable (θ : I → J → ℝ)
variable (p : Fin L → ℝ)
variable (xstar : I → Fin L → ℝ)
variable (ystar : J → Fin L → ℝ)

noncomputable section

-- Budget wealth for consumer i
def wealth (ω : I → Fin L → ℝ) (θ : I → J → ℝ) (p : Fin L → ℝ) (ystar : J → Fin L → ℝ) (i : I) : ℝ :=
  ∑ l : Fin L, p l * ω i l + ∑ j : Finset.univ (α := J), θ i j * ∑ l : Fin L, p l * ystar j l

-- Dot product