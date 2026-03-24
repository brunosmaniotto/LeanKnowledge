import Mathlib

open BigOperators
open Topology

section BayesianNashEquilibrium

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {Θ : I → Type*} [∀ i, Fintype (Θ i)]
variable {S : I → Type*}

/-- The expected payoff in the associated strategic form game G* for player i.
    Vᵢ(σ) = ∑_θ prior(θ) · uᵢ((σⱼ(θⱼ))ⱼ, θ) -/
noncomputable def G.expectedPayoff
    (prior : (∀ i, Θ i) → ℝ)
    (u : I → (∀ i, S i) → (∀ i, Θ i) → ℝ)
    (i : I) (σ : ∀ i, Θ i → S i) : ℝ :=
  ∑ θ : (∀ j, Θ j), prior θ * u i (fun j => σ j (θ j)) θ

/-- Definition 7.12: A Bayesian-Nash equilibrium of a game of incomplete information
    is a Nash equilibrium of the associated strategic form game G*.

    In G*, player i's strategy is a contingent plan σᵢ : Θᵢ → Sᵢ,
    and payoffs are expected values over the common prior.
    σ is a BNE iff no player can unilaterally improve expected payoff:
      ∀ i, ∀ σᵢ', Vᵢ(σ) ≥ Vᵢ(σ₋ᵢ, σᵢ') -/
noncomputable def Definition_7_12
    (prior : (∀ i, Θ i) → ℝ)
    (u : I → (∀ i, S i) → (∀ i, Θ i) → ℝ)
    (σ : ∀ i, Θ i → S i) : Prop :=
  ∀ i : I, ∀ σ_i' : Θ i → S i,
    G.expectedPayoff prior u i σ ≥
    G.expectedPayoff prior u i (Function.update σ i σ_i')

end BayesianNashEquilibrium