import Mathlib

def MWG.IsUpperHemicontinuous {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (φ : X → Set Y) : Prop :=
  ∀ V : Set Y, IsOpen V → IsOpen {x | φ x ⊆ V}