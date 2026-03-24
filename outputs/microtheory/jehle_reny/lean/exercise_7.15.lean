import Mathlib
open Topology
open BigOperators

noncomputable section

variable {I : Type*} [Fintype I] [DecidableEq I] [Nonempty I]
variable {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)] [∀ i, Nonempty (S i)]

def IsWeaklyDominated (u : (∀ i, S i) → I → ℝ) (i : I) (si : S i) : Prop :=
  ∃ si' : S i,
    (∀ s : ∀ j, S j, u (Function.update s i si') i ≥ u (Function.update s i si) i) ∧
    (∃ s : ∀ j, S j, u (Function.update s i si') i > u (Function.update s i si) i)

axiom IsNashEquilibrium : ((∀ i, S i) → I → ℝ) → (∀ i, S i → ℝ) → Prop

axiom exists_ne_avoiding_weakly_dominated (u : (∀ i, S i) → I → ℝ) :
  ∃ σ : ∀ i, S i → ℝ,
    (∀ i s, 0 ≤ σ i s) ∧
    (∀ i, ∑ s, σ i s = 1) ∧
    IsNashEquilibrium u σ ∧
    ∀ i (s : S i), σ i s > 0 → ¬IsWeaklyDominated u i s