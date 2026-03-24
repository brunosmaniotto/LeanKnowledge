import Mathlib

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {Θ : Type*} {X : Type*}

/-- A social choice function f is ex post efficient in a feasible set F if there is no
    other function f̃ in F that weakly dominates f for all agents and states,
    with strict improvement for at least one agent-state pair. -/
def ExPostEfficientInF
    (u : I → X → Θ → ℝ)
    (F : Set (Θ → X))
    (f : Θ → X)
    (hf : f ∈ F) : Prop :=
  ¬ ∃ f' ∈ F,
    (∀ i : I, ∀ θ : Θ, u i (f' θ) θ ≥ u i (f θ) θ) ∧
    (∃ i : I, ∃ θ : Θ, u i (f' θ) θ > u i (f θ) θ)