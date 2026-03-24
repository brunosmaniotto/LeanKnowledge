import Mathlib

variable (I : Type) (T : I → Type)

structure Mechanism where
  expectedUtility : (i : I) → T i → ℝ

variable (IsIncentiveCompatible : Mechanism I T → Prop)
variable (IsExPostEfficient : Mechanism I T → Prop)

noncomputable def IsIndividuallyRational (M : Mechanism I T) (IR : (i : I) → T i → ℝ) : Prop :=
  ∀ (i : I) (t_i : T i), M.expectedUtility i t_i ≥ IR i t_i