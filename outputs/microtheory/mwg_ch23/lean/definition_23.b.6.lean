import Mathlib

/-- A social choice function is truthfully implementable (incentive compatible)
    if truth telling by each agent constitutes an equilibrium of the direct
    revelation mechanism Γ = (Θ₁,...,Θ_I, f(·)). The equilibrium concept is
    left unspecified via a predicate parameter. -/
def TruthfullyImplementable
    {I : Type*} [Fintype I]
    {Θ : I → Type*}
    {X : Type*}
    (f : (∀ i, Θ i) → X)
    (isEquilibrium : ((∀ i, Θ i → Θ i) → Prop)) : Prop :=
  isEquilibrium (fun i => id)