import Mathlib

open Classical

-- A direct mechanism for agents I, type spaces T, and outcome space X
structure DirectMechanism (I : Type*) [Fintype I] (T : I → Type*) (X : Type*) where
  expectedUtility : ∀ i, T i → T i → ℝ  -- expected utility when true type is t_i, report is r_i
  IR : ∀ i, T i → ℝ                     -- individual rationality value for type t_i

-- Incentive compatibility: truthful reporting is optimal
noncomputable def IsIncentiveCompatible {I : Type*} [Fintype I] {T : I → Type*} {X : Type*}
  (M : DirectMechanism I T X) : Prop :=
  ∀ i (t_i : T i) (r_i : T i), M.expectedUtility i t_i t_i ≥ M.expectedUtility i t_i r_i

-- Individual rationality: expected utility from truth-telling ≥ IR value