import Mathlib
open BigOperators
open Topology

theorem Claim_4B_a
    {J : Type*} [Fintype J]
    (x : J → ℝ → ℝ)
    : (∃ f : ℝ → ℝ, ∀ w : J → ℝ, f (∑ i, w i) = ∑ i, x i (w i))
      ↔ (∀ w w' : J → ℝ, (∑ i, w i) = (∑ i, w' i) →
          (∑ i, x i (w i)) = (∑ i, x i (w' i))) := by
  constructor
  · rintro ⟨f, hf⟩ w w' heq
    rw [← hf w, ← hf w', heq]
  · intro h
    classical
    let π : (J → ℝ) → ℝ := fun w => ∑ i, w i
    exact ⟨fun s => ∑ i, x i (Function.invFun π s i),
      fun w => h _ _ (Function.invFun_eq ⟨w, rfl⟩)⟩