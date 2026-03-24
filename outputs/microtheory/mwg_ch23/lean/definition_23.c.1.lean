import Mathlib
open Topology

/-- A mechanism consists of strategy sets and an outcome function. -/
structure Mechanism (I : Type*) (S : I → Type*) (Outcome : Type*) where
  g : (∀ i, S i) → Outcome

/-- A dominant strategy equilibrium of mechanism Γ = (S₁,...,Sᵢ, g(·)).
    The strategy profile s*(·) is a dominant strategy equilibrium if for all i and all θ_i,
    u_i(g(s_i*(θ_i), s_{-i}), θ_i) ≥ u_i(g(s_i, s_{-i}), θ_i)
    for all s_i ∈ S_i and all s_{-i} ∈ S_{-i}.

    We model s_{-i} as any full profile `t : ∀ j, S j` and require that replacing
    player i's component with s_i*(θ_i) is weakly better than any alternative s_i,
    holding others fixed. -/
structure DominantStrategyEquilibrium
    {I : Type*} [DecidableEq I]
    {S : I → Type*} {Outcome : Type*} {Θ : I → Type*}
    (Γ : Mechanism I S Outcome)
    (u : ∀ i, Outcome → Θ i → ℝ) where
  strategy : ∀ i, Θ i → S i
  dominates : ∀ (i : I) (θ_i : Θ i) (s_i : S i) (s_minus_i : ∀ j, S j),
    u i (Γ.g (Function.update s_minus_i i (strategy i θ_i))) θ_i ≥
    u i (Γ.g (Function.update s_minus_i i s_i)) θ_i