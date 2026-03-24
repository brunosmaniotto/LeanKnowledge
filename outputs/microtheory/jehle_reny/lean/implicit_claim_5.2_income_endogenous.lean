import Mathlib

open BigOperators Finset
open Topology

/-- In an exchange economy with L goods, consumer i's income is the dot product
    of the price vector and the endowment vector, hence endogenous in prices. -/
theorem income_endogenous
    {L : ℕ} (p₁ p₂ : Fin L → ℝ) (eᵢ : Fin L → ℝ)
    (hp : p₁ ≠ p₂) :
    let income (p : Fin L → ℝ) := ∑ l : Fin L, p l * eᵢ l
    income p₁ = ∑ l, p₁ l * eᵢ l ∧
    income p₂ = ∑ l, p₂ l * eᵢ l := by
  constructor <;> simp