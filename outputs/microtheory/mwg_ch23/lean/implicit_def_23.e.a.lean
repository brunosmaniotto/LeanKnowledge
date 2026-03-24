import Mathlib
open Topology
open BigOperators

/-! # Participation (Individual Rationality) Constraints

Three types of IR constraints depending on when agents can withdraw.
-/

variable {N : Type*} [Fintype N] [DecidableEq N]
variable {Θ : N → Type*} [∀ i, Fintype (Θ i)] [∀ i, DecidableEq (Θ i)]
variable {X : Type*}

/-- A type profile: each agent reports a type. -/
abbrev TypeProfile (Θ : N → Type*) := ∀ i, Θ i

/-- Ex post individual rationality: for every type profile, each agent prefers
    the outcome to withdrawing. -/
structure ExPostIR
    (f : TypeProfile Θ → X)
    (u : N → X → (∀ i, Θ i) → ℝ)
    (u_bar : ∀ i, Θ i → ℝ) : Prop where
  constraint : ∀ (i : N) (θ : TypeProfile Θ),
    u i (f θ) θ ≥ u_bar i (θ i)

/-- Interim individual rationality: for each agent, the expected utility
    conditional on own type meets the reservation utility.
    Here `φ_{-i}` gives a probability weight for each profile of others' types. -/
structure InterimIR
    (f : TypeProfile Θ → X)
    (u : N → X → (∀ i, Θ i) → ℝ)
    (u_bar : ∀ i, Θ i → ℝ)
    (φ_neg : ∀ (i : N), Θ i → TypeProfile Θ → ℝ) : Prop where
  constraint : ∀ (i : N) (θ_i : Θ i),
    (∑ θ : TypeProfile Θ, φ_neg i θ_i θ * u i (f θ) θ) ≥ u_bar i θ_i

/-- Ex ante individual rationality: each agent's ex ante expected utility
    (before learning own type) meets the expected reservation utility.
    Here `φ` gives a joint probability over the full type profile. -/
structure ExAnteIR
    (f : TypeProfile Θ → X)
    (u : N → X → (∀ i, Θ i) → ℝ)
    (u_bar : ∀ i, Θ i → ℝ)
    (φ : TypeProfile Θ → ℝ)
    (φ_i : ∀ i, Θ i → ℝ) : Prop where
  constraint : ∀ (i : N),
    (∑ θ : TypeProfile Θ, φ θ * u i (f θ) θ) ≥
    (∑ t_i : Θ i, φ_i i t_i * u_bar i t_i)