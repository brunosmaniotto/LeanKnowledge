import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {n : ℕ} [NeZero n]

def BudgetSet (p : Fin n → ℝ) (w : ℝ) : Set (Fin n → ℝ) :=
  {y | ∑ i, p i * y i ≤ w}

structure RationalPref (α : Type*) where
  pref : α → α → Prop
  complete : ∀ x y, pref x y ∨ pref y x
  trans : ∀ x y z, pref x y → pref y z → pref x z