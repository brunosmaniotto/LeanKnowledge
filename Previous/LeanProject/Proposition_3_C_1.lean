import Mathlib.Topology.Basic
import Mathlib.Topology.Order.Basic
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Data.Real.Basic

open Set

/-- A preference relation R on X is continuous if for all y in X,
    the upper contour set {x | R x y} and the lower contour set {x | R y x} are closed. -/
def PreferenceContinuous {α : Type*} [TopologicalSpace α] (R : α → α → Prop) : Prop :=
  (∀ y, IsClosed {x | R x y}) ∧ (∀ y, IsClosed {x | R y x})

/-- A utility function u represents a preference relation R. -/
def Represents {α : Type*} (u : α → �) (R : α → α → Prop) : Prop :=
  ∀ x y, R x y � u y ≤ u x

/-- Proposition 3.C.1: Continuous rational preferences have a continuous utility representation.
    We formalize the statement for X = (Fin L → �). -/
theorem utility_representation_exists (L : ℕ)
    (R : (Fin L → �) → (Fin L → �) → Prop)
    (h_rational_comp : ∀ x y, R x y ∨ R y x)
    (h_rational_trans : ∀ x y z, R x y → R y z → R x z)
    (hcont : PreferenceContinuous R) :
    ∃ u : (Fin L → �) → �, Continuous u ∧ Represents u R := sorry
