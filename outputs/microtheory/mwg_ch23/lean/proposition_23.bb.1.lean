import Mathlib
open Topology

variable {N Outcome Θ S : Type*} [DecidableEq N]

/-- Strong implementation: for every θ there exists a Nash equilibrium with outcome f(θ),
    and every Nash equilibrium at θ must yield outcome f(θ). -/
structure StrongImpl (f : Θ → Outcome) (g : (N → S) → Outcome)
    (L : N → Outcome → Θ → Set Outcome) where
  nash_exists : ∀ θ, ∃ s : N → S, g s = f θ ∧
    ∀ (i : N) (si : S), g (Function.update s i si) ∈ L i (f θ) θ
  nash_unique : ∀ θ (s : N → S),
    (∀ (i : N) (si : S), g (Function.update s i si) ∈ L i (f θ) θ) → g s = f θ

def Monotonic (f : Θ → Outcome) (L : N → Outcome → Θ → Set Outcome) : Prop :=
  ∀ θ θ', (∀ i, L i (f θ) θ ⊆ L i (f θ) θ') → f θ' = f θ