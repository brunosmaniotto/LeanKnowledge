import Mathlib

def StrictlyDominates
    (I : Type*) [Fintype I] [DecidableEq I]
    (S : I → Type*) [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)] [∀ i, Nonempty (S i)]
    (u : (∀ i, PMF (S i)) → I → ℝ)
    (i : I) (σ'_i σ_i : PMF (S i)) : Prop :=
  ∀ σ : ∀ j, PMF (S j),
    u (Function.update σ i σ'_i) i > u (Function.update σ i σ_i) i