import Mathlib
open Topology

theorem claim_A1_4_2_b (f : ℝ → ℝ) (s : Set ℝ) (hs : Convex ℝ s) :
    ConcaveOn ℝ s f ↔
      (∀ x₁ ∈ s, ∀ x₂ ∈ s, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
        t • f x₁ + (1 - t) • f x₂ ≤ f (t • x₁ + (1 - t) • x₂)) := by
  constructor
  · intro ⟨_, hf⟩ x₁ hx₁ x₂ hx₂ t ht0 ht1
    exact hf hx₁ hx₂ ht0 (by linarith) (by linarith)
  · intro h
    refine ⟨hs, fun {x₁} hx₁ {x₂} hx₂ a b ha hb hab => ?_⟩
    have hb_eq : b = 1 - a := by linarith
    have ha1 : a ≤ 1 := by linarith
    rw [hb_eq]
    exact h x₁ hx₁ x₂ hx₂ a ha ha1