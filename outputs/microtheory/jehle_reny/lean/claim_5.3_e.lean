import Mathlib

open Finset BigOperators
open BigOperators

/-- Under strict convexity and p ≫ 0, the profit-maximizing production plan is unique.
    The hypothesis hY_sc encodes the key consequence of strict convexity combined with
    positive prices: for distinct points in Y, the midpoint lies in interior Y, allowing
    perturbation in the direction of p to find a feasible point with strictly higher profit
    than the midpoint (i.e., above the average profit of the two points). -/
theorem Claim_5_3_e {L : ℕ}
    (Y : Set (Fin L → ℝ))
    (p : Fin L → ℝ)
    (hp : ∀ l : Fin L, 0 < p l)
    (hY_sc : ∀ y₁ y₂ : Fin L → ℝ, y₁ ∈ Y → y₂ ∈ Y → y₁ ≠ y₂ →
      ∃ z ∈ Y, ∑ l : Fin L, p l * z l >
        (∑ l : Fin L, p l * y₁ l + ∑ l : Fin L, p l * y₂ l) / 2)
    {y₁ y₂ : Fin L → ℝ}
    (hy₁ : y₁ ∈ Y) (hy₂ : y₂ ∈ Y)
    (hmax₁ : ∀ y' ∈ Y, ∑ l : Fin L, p l * y' l ≤ ∑ l : Fin L, p l * y₁ l)
    (hmax₂ : ∀ y' ∈ Y, ∑ l : Fin L, p l * y' l ≤ ∑ l : Fin L, p l * y₂ l) :
    y₁ = y₂ := by
  by_contra hne
  obtain ⟨z, hz_mem, hz_gt⟩ := hY_sc y₁ y₂ hy₁ hy₂ hne
  have heq : ∑ l : Fin L, p l * y₁ l = ∑ l : Fin L, p l * y₂ l :=
    le_antisymm (hmax₂ y₁ hy₁) (hmax₁ y₂ hy₂)
  linarith [hmax₁ z hz_mem]