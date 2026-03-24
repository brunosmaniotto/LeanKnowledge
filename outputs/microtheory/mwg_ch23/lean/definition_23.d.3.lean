import Mathlib
open BigOperators
open Topology

/-- A Bayesian mechanism design setting with finite agents and finite type spaces. -/
structure BayesianMechanismDesign where
  I : ℕ
  Θ : Fin I → Type*
  X : Type*
  [inst_fin : ∀ i, Fintype (Θ i)]
  [inst_dec : ∀ i, DecidableEq (Θ i)]
  /-- Agent i's utility from outcome x when their type is θ_i -/
  u : (i : Fin I) → X → Θ i → ℝ
  /-- Agent i's belief: probability weight on profile θ given own type θ_i -/
  prob : (i : Fin I) → Θ i → (∀ j, Θ j) → ℝ
  /-- Social choice function -/
  f : (∀ i, Θ i) → X

attribute [instance] BayesianMechanismDesign.inst_fin BayesianMechanismDesign.inst_dec

/-- A social choice function f(·) is truthfully implementable in Bayesian Nash equilibrium
(Bayesian incentive compatible) if for every agent i and every type θ_i ∈ Θ_i,
reporting truthfully maximizes expected utility:
  E_{θ_{-i}}[u_i(f(θ_i, θ_{-i}), θ_i) | θ_i] ≥ E_{θ_{-i}}[u_i(f(θ̂_i, θ_{-i}), θ_i) | θ_i]
for all θ̂_i ∈ Θ_i. -/
def BayesianIncentiveCompatible (md : BayesianMechanismDesign) : Prop :=
  ∀ (i : Fin md.I) (θ_i : md.Θ i) (θ_hat : md.Θ i),
    (∑ θ : (∀ j, md.Θ j),
      if θ i = θ_i then
        md.prob i θ_i θ * md.u i (md.f θ) θ_i
      else 0)
    ≥
    (∑ θ : (∀ j, md.Θ j),
      if θ i = θ_i then
        md.prob i θ_i θ * md.u i (md.f (Function.update θ i θ_hat)) θ_i
      else 0)