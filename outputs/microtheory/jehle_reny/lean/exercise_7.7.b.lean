import Mathlib

open Finset BigOperators

theorem Exercise_7_7_b
    {S₁ S₂ : Type*} [Fintype S₁] [Fintype S₂]
    (E : (S₁ → ℝ) → (S₂ → ℝ) → ℝ)
    {m1 m1' : S₁ → ℝ} {m2 m2' : S₂ → ℝ}
    (h1_opt : ∀ σ : S₁ → ℝ, E σ m2 ≤ E m1 m2)
    (h2_opt : ∀ σ : S₂ → ℝ, E m1 m2 ≤ E m1 σ)
    (h1'_opt : ∀ σ : S₁ → ℝ, E σ m2' ≤ E m1' m2')
    (h2'_opt : ∀ σ : S₂ → ℝ, E m1' m2' ≤ E m1' σ) :
    (∀ σ : S₁ → ℝ, E σ m2' ≤ E m1 m2') ∧
    (∀ σ : S₂ → ℝ, E m1 m2' ≤ E m1 σ) ∧
    (∀ σ : S₁ → ℝ, E σ m2 ≤ E m1' m2) ∧
    (∀ σ : S₂ → ℝ, E m1' m2 ≤ E m1' σ) := by
  have h_a : E m1' m2 ≤ E m1 m2 := h1_opt m1'
  have h_b : E m1' m2' ≤ E m1' m2 := h2'_opt m2
  have h_c : E m1 m2' ≤ E m1' m2' := h1'_opt m1
  have h_d : E m1 m2 ≤ E m1 m2' := h2_opt m2'
  -- Chain: E m1 m2 ≤ E m1 m2' ≤ E m1' m2' ≤ E m1' m2 ≤ E m1 m2
  -- So all are equal
  have heq1 : E m1 m2 = E m1 m2' := le_antisymm h_d (by linarith)
  have heq2 : E m1 m2' = E m1' m2' := le_antisymm h_c (by linarith)
  have heq3 : E m1' m2' = E m1' m2 := le_antisymm h_b (by linarith)
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro σ; linarith [h1'_opt σ]
  · intro σ; linarith [h2_opt σ]
  · intro σ; linarith [h1_opt σ]
  · intro σ; linarith [h2'_opt σ]