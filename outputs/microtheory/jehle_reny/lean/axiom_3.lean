import Mathlib

open Set Topology
open Topology

/-- Continuity of preferences (Axiom 3, MWG Definition 3.C.1).
    A preference relation ≿ on ℝⁿ₊ is continuous if for every x,
    the upper contour set {y | y ≿ x} and the lower contour set {y | x ≿ y}
    are both closed in ℝⁿ₊. -/
def MWG.IsContinuousOn {n : ℕ} (pref : (Fin n → ℝ) → (Fin n → ℝ) → Prop) : Prop :=
  ∀ x : Fin n → ℝ, IsClosed {y : Fin n → ℝ | pref y x} ∧ IsClosed {y : Fin n → ℝ | pref x y}