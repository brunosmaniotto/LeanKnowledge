import Mathlib
open Topology

-- Model the consumer's problem abstractly
variable {X : Type*} [TopologicalSpace X]
variable (pref : X → X → Prop)  -- x ≿ y means pref x y
variable (p_dot : X → ℝ)  -- p · x_i
variable (w : ℝ)  -- wealth

-- Maximality: x* is maximal for ≿ in budget set
def IsMaximalInBudget (xstar : X) : Prop :=
  p_dot xstar ≤ w ∧ ∀ y, p_dot y ≤ w → pref y xstar → pref xstar y

-- Local nonsatiation: for any x and ε > 0, there exists y near x with y ≻ x
-- (y strictly preferred: pref y x ∧ ¬ pref x y)