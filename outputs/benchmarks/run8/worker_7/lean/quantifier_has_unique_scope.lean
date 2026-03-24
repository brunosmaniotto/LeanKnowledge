import Mathlib

namespace Predicate

-- Terms: variables and function applications
inductive Term
  | var : String → Term
  | func : String → List Term → Term

-- Well-formed formulas
inductive Formula
  | atomic : String → List Term → Formula
  | and : Formula → Formula → Formula
  | or : Formula → Formula → Formula
  | imp : Formula → Formula → Formula
  | not : Formula → Formula
  | forall : String → Formula → Formula
  | exists : String → Formula → Formula

-- Subformula relation (including the formula itself)
inductive Subformula : Formula → Formula → Prop
  | refl (φ : Formula) : Subformula φ φ
  | not (φ ψ : Formula) : Subformula φ ψ → Subformula φ (Formula.not ψ)
  | and_left (φ ψ χ : Formula) : Subformula φ ψ → Subformula φ (Formula.and ψ χ)
  | and_right (φ ψ χ : Formula) : Subformula φ χ → Subformula φ (Formula.and ψ χ)
  | or_left (φ ψ χ : Formula) : Subformula φ ψ → Subformula φ (Formula.or ψ χ)
  | or_right (φ ψ χ : Formula) : Subformula φ χ → Subformula φ (Formula.or ψ χ)
  | imp_left (φ ψ χ : Formula) : Subformula φ ψ → Subformula φ (Formula.imp ψ χ)
  | imp_right (φ ψ χ : Formula) : Subformula φ χ → Subformula φ (Formula.imp ψ χ)
  | forall (φ ψ : Formula) (x : String) : Subformula φ ψ → Subformula φ (Formula.forall x ψ)
  | exists (φ ψ : Formula) (x : String) : Subformula φ ψ → Subformula φ (Formula.exists x ψ)

-- A quantifier is either ∀ or ∃
def isQuantifier (φ : Formula) : Prop :=
  ∃ (x : String) (ψ : Formula), φ = Formula.forall x ψ ∨ φ = Formula.exists x ψ

-- Two subformulas are the same occurrence if they are syntactically equal at the same position
-- We'll prove that if two subformulas both start with the same quantifier occurrence, they must be the same