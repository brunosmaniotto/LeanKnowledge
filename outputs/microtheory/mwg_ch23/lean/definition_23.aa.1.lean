import Mathlib

/-- A mechanism (strategy spaces + outcome function) strongly implements a social choice function
    if *every* equilibrium strategy profile reproduces the SCF outcome for all type profiles. -/
def Mechanism.stronglyImplements
    {I : Type*} [Fintype I] [DecidableEq I]
    {S : I → Type*} {X : Type*} {Θ : I → Type*}
    (g : (∀ i, S i) → X)
    (Equilibrium : ((∀ i, Θ i → S i) → Prop))
    (f : (∀ i, Θ i) → X) : Prop :=
  ∀ σ : ∀ i, Θ i → S i,
    Equilibrium σ →
      ∀ θ : ∀ i, Θ i,
        g (fun i => σ i (θ i)) = f θ