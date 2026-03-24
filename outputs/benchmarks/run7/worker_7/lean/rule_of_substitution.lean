import Mathlib.Data.Multiset.Basic

open Multiset

inductive Formula : Type
  | atom : Nat → Formula
  | and : Formula → Formula → Formula
  | false : Formula

def subst (σ : Nat → Formula) : Formula → Formula
  | Formula.atom a => σ a
  | Formula.and A B => Formula.and (subst σ A) (subst σ B)
  | Formula.false => Formula.false

inductive Proves : Multiset Formula → Multiset Formula → Prop
  | axiom (A : Formula) : Proves {A} {A}
  | and_left (Γ Δ : Multiset Formula) (A B : Formula) (h : Proves (A ::ₘ Γ) Δ) : Proves (Formula.and A B ::ₘ Γ) Δ