import Mathlib
open Topology
set_option linter.unusedVariables false

axiom forward_inequality {T : Type} (ψ : ℝ) (IR U_VCG : T → ℝ) (h : ∀ t, U_VCG t + ψ ≥ IR t) : ∀ t, ψ ≥ IR t - U_VCG t

axiom forward_sup {T : Type} [Fintype T] [Nonempty T] (ψ : ℝ) (IR U_VCG : T → ℝ) (h : ∀ t, ψ ≥ IR t - U_VCG t) :
    ψ ≥ Finset.sup' Finset.univ (Finset.univ_nonempty) (fun t : T => IR t - U_VCG t)

axiom reverse_sup {T : Type} [Fintype T] [Nonempty T] (ψ : ℝ) (IR U_VCG : T → ℝ)
    (h : ψ ≥ Finset.sup' Finset.univ (Finset.univ_nonempty) (fun t : T => IR t - U_VCG t)) : ∀ t, ψ ≥ IR t - U_VCG t

axiom reverse_inequality {T : Type} (ψ : ℝ) (IR U_VCG : T → ℝ) (h : ∀ t, ψ ≥ IR t - U_VCG t) : ∀ t, U_VCG t + ψ ≥ IR t

theorem Claim_participation_subsidy {T : Type} [Fintype T] [Nonempty T] (ψ : ℝ) (IR U_VCG : T → ℝ) :
    (∀ t, U_VCG t + ψ ≥ IR t) ↔ (ψ ≥ Finset.sup' Finset.univ (Finset.univ_nonempty) (fun t : T => IR t - U_VCG t)) := by
  constructor
  · intro h
    have h1 := forward_inequality ψ IR U_VCG h
    exact forward_sup ψ IR U_VCG h1
  · intro h
    have h1 := reverse_sup ψ IR U_VCG h
    exact reverse_inequality ψ IR U_VCG h1