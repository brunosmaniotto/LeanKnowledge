import Mathlib

open Set

variable {I : ℕ} {X : Type} [Fintype X]
variable (v : Fin I → X → ℝ → ℝ)
variable (ExPostEfficientAt : (Fin I → ℝ) → Set X)

noncomputable def UniqueExPostEfficient (t : Fin I → ℝ) : Prop := ∃! x, x ∈ ExPostEfficientAt t

structure Mechanism where
  -- Mechanism structure left abstract for the proof
  -- In practice would contain allocation and transfer functions

variable (IncentiveCompatible : Mechanism → Prop)
variable (ExPostEfficient : Mechanism → Prop)
variable (BudgetBalanced : Mechanism → Prop)
variable (IndividuallyRational : Mechanism → Prop)
variable (IR_VCG_mechanism : Mechanism)
variable (expected_revenue : Mechanism → ℝ)