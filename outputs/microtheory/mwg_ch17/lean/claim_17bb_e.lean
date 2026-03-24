import Mathlib
open Topology
open BigOperators

theorem Claim_17BB_e
    {n : ℕ}
    (Y₁ : Set (Fin n → ℝ))
    (free_disposal : ∀ y ∈ Y₁, ∀ y' : Fin n → ℝ, (∀ i, y' i ≤ y i) → y' ∈ Y₁)
    (y₁_star : Fin n → ℝ)
    (hy₁ : y₁_star ∈ Y₁)
    (p : Fin n → ℝ)
    (profit_max : ∀ y ∈ Y₁, ∑ i, p i * y i ≤ ∑ i, p i * y₁_star i)
    : ∃ yt ∈ Y₁, (∀ i, yt i ≤ y₁_star i) ∧
        (∀ y ∈ Y₁, ∑ i, p i * y i ≤ ∑ i, p i * yt i) :=
  ⟨y₁_star, hy₁, fun i => le_refl _, profit_max⟩