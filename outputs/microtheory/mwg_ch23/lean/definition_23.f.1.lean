import Mathlib

/-- A social choice function is ex ante efficient in a set F if there is no other
    function in F that weakly Pareto dominates it (weakly better for all agents,
    strictly better for some). -/
def ExAnteEfficientInF
    {I : Type*} [Fintype I]
    {Θ : Type*} {X : Type*}
    (U : (Θ → X) → I → ℝ)
    (F : Set (Θ → X))
    (f : Θ → X) : Prop :=
  f ∈ F ∧
  ¬∃ g ∈ F,
    (∀ i, U g i ≥ U f i) ∧
    (∃ i, U g i > U f i)