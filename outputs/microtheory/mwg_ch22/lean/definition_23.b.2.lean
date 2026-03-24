import Mathlib

/-- A social choice function is ex post efficient (Paretian) if for no type profile θ
    is there an alternative x that Pareto dominates f(θ). -/
def ExPostEfficient
    {I : Type*} [Fintype I]
    {X : Type*}
    {Θ : I → Type*}
    (f : (∀ i, Θ i) → X)
    (u : ∀ i, X → Θ i → ℝ) : Prop :=
  ∀ (θ : ∀ i, Θ i), ¬∃ (x : X),
    (∀ i, u i x (θ i) ≥ u i (f θ) (θ i)) ∧
    (∃ i, u i x (θ i) > u i (f θ) (θ i))