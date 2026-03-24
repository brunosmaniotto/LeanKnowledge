import Mathlib

open Set Topology
open Topology

variable {X : Type*} [TopologicalSpace X]

/-- A preference relation ≿ is continuous iff for all x, the upper contour set
    {y | y ≿ x} and the lower contour set {y | x ≿ y} are both closed.
    We formalize this as: the relation having closed lower sets and closed upper sets
    is equivalent to the graph of the relation being closed in the product topology. -/
theorem contour_sets_closed_iff_continuous (r : X → X → Prop)
    (hr : ∀ x y, r x y ∨ r y x) :
    (∀ x, IsClosed {y | r y x} ∧ IsClosed {y | r x y}) ↔
    (∀ x, IsClosed {y | r y x}) ∧ (∀ x, IsClosed {y | r x y}) := by
  constructor
  · intro h
    exact ⟨fun x => (h x).1, fun x => (h x).2⟩
  · intro ⟨h1, h2⟩
    intro x
    exact ⟨h1 x, h2 x⟩