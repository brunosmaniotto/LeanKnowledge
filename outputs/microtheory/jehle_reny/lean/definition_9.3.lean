import Mathlib

open BigOperators Finset

/-- An allocation function x̂ : T → X is ex post Pareto-efficient if for each
    type profile t, x̂(t) maximizes the social surplus Σᵢ vᵢ(x, tᵢ) over all x ∈ X. -/
def IsExPostParetoEfficient
    {N : ℕ} {T : Fin N → Type*} {X : Type*}
    (v : (i : Fin N) → X → T i → ℝ)
    (x_hat : ((i : Fin N) → T i) → X) : Prop :=
  ∀ (t : (i : Fin N) → T i) (x : X),
    ∑ i : Fin N, v i (x_hat t) (t i) ≥ ∑ i : Fin N, v i x (t i)