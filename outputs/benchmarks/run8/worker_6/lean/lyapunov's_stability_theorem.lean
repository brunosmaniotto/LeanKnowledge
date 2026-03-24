import Mathlib

open Function Set Filter
open scoped Topology

/-- A fixed point `x0` is stable if for every neighborhood `U` of `x0`, there exists a neighborhood
    `V` of `x0` such that every orbit starting in `V` remains in `U`. -/
def IsStable {X : Type*} [TopologicalSpace X] (f : X → X) (x0 : X) : Prop :=
  ∀ U ∈ 𝓝 x0, ∃ V ∈ 𝓝 x0, ∀ y ∈ V, ∀ n, (f^[n]) y ∈ U