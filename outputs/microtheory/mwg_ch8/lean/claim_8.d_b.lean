import Mathlib
open Topology

universe u

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)] [∀ i, Nonempty (S i)]
variable (utility : (∀ i, S i) → I → ℝ)

def IsNashEquilibrium (σ : ∀ i, S i) : Prop :=
  ∀ i : I, ∀ s' : S i, utility σ i ≥ utility (Function.update σ i s') i

noncomputable def Rationalizable (n : ℕ) : ∀ i, Set (S i) :=
  match n with
  | 0 => fun i => Set.univ
  | n + 1 => fun i => { s : S i |
      ∃ σ : ∀ j, S j, σ i = s ∧
        (∀ j, σ j ∈ Rationalizable n j) ∧
        ∀ s' : S i, utility (Function.update σ i s) i ≥ utility (Function.update σ i s') i }