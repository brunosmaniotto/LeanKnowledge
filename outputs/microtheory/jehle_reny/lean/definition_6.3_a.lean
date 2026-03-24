import Mathlib

/-- Anonymity (Definition 6.3 A): A social welfare function W is anonymous if
    W(u) = W(u ∘ σ) for every permutation σ of individuals. -/
def Anonymity (N : ℕ) (W : (Fin N → ℝ) → ℝ) : Prop :=
  ∀ (u : Fin N → ℝ) (σ : Equiv.Perm (Fin N)), W u = W (u ∘ σ)