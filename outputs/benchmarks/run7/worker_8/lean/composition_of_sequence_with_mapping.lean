import Mathlib

theorem sequence_comp {α : Type} {A B : Set ℕ} (f : B → α) (σ : A → B) (k : A) :
    (f ∘ σ) k = f (σ k) :=
  rfl