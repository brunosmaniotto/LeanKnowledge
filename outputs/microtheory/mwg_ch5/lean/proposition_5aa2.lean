import Mathlib

open BigOperators
open Topology

theorem Proposition_5AA2
    (L : ℕ) (hL : 2 ≤ L)
    (n : ℕ) (hn : n = L - 1)
    (Y : Set (Fin L → ℝ))
    (efficient : (Fin L → ℝ) → Prop)
    (eff_in_Y : ∀ y, efficient y → y ∈ Y)
    (activity_generation : ∀ y, y ∈ Y →
      ∃ (a : Fin n → Fin L → ℝ) (α : Fin n → ℝ),
        (∀ ℓ, 0 ≤ α ℓ) ∧ ∀ j : Fin L, y j = ∑ ℓ : Fin n, α ℓ * a ℓ j)
    (productive : ∃ y, efficient y ∧ ∀ i : Fin n, 0 < y ⟨i.val, by omega⟩)
    (nonsubstitution : ∀ (a : Fin n → Fin L → ℝ) (α : Fin n → ℝ),
      (∀ ℓ, 0 < α ℓ) →
      (∃ y, efficient y ∧ ∀ j : Fin L, y j = ∑ ℓ : Fin n, α ℓ * a ℓ j) →
      ∀ y, efficient y → (∀ i : Fin n, 0 < y ⟨i.val, by omega⟩) →
        ∃ α' : Fin n → ℝ, (∀ ℓ, 0 ≤ α' ℓ) ∧
          ∀ j : Fin L, y j = ∑ ℓ : Fin n, α' ℓ * a ℓ j)
    (pos_activity_levels : ∀ y, efficient y →
      (∀ i : Fin n, 0 < y ⟨i.val, by omega⟩) →
      ∀ (a : Fin n → Fin L → ℝ) (α : Fin n → ℝ),
        (∀ ℓ, 0 ≤ α ℓ) → (∀ j : Fin L, y j = ∑ ℓ : Fin n, α ℓ * a ℓ j) →
        ∀ ℓ, 0 < α ℓ) :
    ∃ a : Fin n → Fin L → ℝ,
      ∀ y, efficient y → (∀ i : Fin n, 0 < y ⟨i.val, by omega⟩) →
        ∃ α : Fin n → ℝ, (∀ ℓ, 0 ≤ α ℓ) ∧
          ∀ j : Fin L, y j = ∑ ℓ : Fin n, α ℓ * a ℓ j := by
  obtain ⟨y₀, hy₀eff, hy₀pos⟩ := productive
  obtain ⟨a₀, α₀, hα₀nn, hgen₀⟩ := activity_generation y₀ (eff_in_Y y₀ hy₀eff)
  exact ⟨a₀, fun y hy hypos =>
    nonsubstitution a₀ α₀
      (pos_activity_levels y₀ hy₀eff hy₀pos a₀ α₀ hα₀nn hgen₀)
      ⟨y₀, hy₀eff, hgen₀⟩ y hy hypos⟩