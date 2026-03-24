import Mathlib

open Set Filter Topology
open Topology

noncomputable section

def IsUpperHemicontinuous {Q X : Type*} [TopologicalSpace Q] [TopologicalSpace X]
    (Φ : Q → Set X) : Prop :=
  ∀ q, ∀ U : Set X, IsOpen U → Φ q ⊆ U → ∃ V ∈ 𝓝 q, ∀ q' ∈ V, Φ q' ⊆ U