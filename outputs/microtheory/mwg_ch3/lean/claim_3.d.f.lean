import Mathlib

theorem indirect_utility_transforms
    {X : Type*} (B : Set X) (u : X → ℝ) (f : ℝ → ℝ)
    (hf : StrictMono f)
    (x_star : X) (hx_mem : x_star ∈ B)
    (hmax : ∀ x ∈ B, u x ≤ u x_star) :
    (∀ x ∈ B, f (u x) ≤ f (u x_star)) ∧ f (u x_star) = f (u x_star) := by
  exact ⟨fun x hx => hf.monotone (hmax x hx), rfl⟩