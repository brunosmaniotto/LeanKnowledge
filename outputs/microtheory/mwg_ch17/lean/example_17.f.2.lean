import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Example_17_F_2
    (n : ℕ) (hn : 0 < n)
    (α ω p : Fin n → ℝ)
    (hp_pos : ∀ i, 0 < p i) :
    let wealth := ∑ i : Fin n, p i * ω i
    let z := fun ℓ => α ℓ * wealth / p ℓ - ω ℓ
    let cross_effect := fun ℓ k => α ℓ * ω k / p ℓ
    (∀ ℓ, z ℓ = α ℓ * wealth / p ℓ - ω ℓ) ∧
    (∀ ℓ k, 0 < α ℓ → (0 < cross_effect ℓ k ↔ 0 < ω k)) := by
  constructor
  · intro ℓ; rfl
  · intro ℓ k hα
    simp only
    constructor
    · intro h
      have hpℓ : 0 < p ℓ := hp_pos ℓ
      rw [div_pos_iff] at h
      rcases h with ⟨h1, _⟩ | ⟨_, h2⟩
      · by_contra hle
        push_neg at hle
        nlinarith [mul_nonpos_of_nonneg_of_nonpos (le_of_lt hα) hle]
      · linarith
    · intro hωk
      exact div_pos (mul_pos hα hωk) (hp_pos ℓ)