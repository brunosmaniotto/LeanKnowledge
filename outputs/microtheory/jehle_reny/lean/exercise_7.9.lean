import Mathlib
open Topology

/-- A symmetric two-person zero-sum game. Player 1's payoff is u(s₁, s₂),
    player 2's payoff is -u(s₁, s₂). Symmetry means u(s₁, s₂) = -u(s₂, s₁). -/
theorem Exercise_7_9
    (S : Type*) [Nonempty S]
    (u : S → S → ℝ)
    (symmetric : ∀ s₁ s₂ : S, u s₁ s₂ = -u s₂ s₁)
    (v : ℝ)
    (hv : ∀ s₁ s₂ : S, u s₁ s₂ ≤ v)
    (hv' : ∀ s₁ s₂ : S, -u s₁ s₂ ≤ -v)
    : v = 0 := by
  have h1 : ∀ s₁ s₂ : S, u s₁ s₂ ≤ v := hv
  have h2 : ∀ s₁ s₂ : S, u s₂ s₁ ≤ v := fun s₁ s₂ => hv s₂ s₁
  have h3 : ∀ s₁ s₂ : S, -u s₁ s₂ ≤ v := by
    intro s₁ s₂
    have := h2 s₁ s₂
    rw [symmetric s₂ s₁] at this
    linarith
  obtain ⟨s⟩ := ‹Nonempty S›
  have hpos : v ≥ 0 := by linarith [h1 s s, h3 s s, symmetric s s]
  have hneg : v ≤ 0 := by
    have := hv' s s
    linarith [hv s s, symmetric s s]
  linarith