import Mathlib

open Filter
open Topology

theorem continuousAt_iff_tendsto_filters {S₁ S₂ : Type*} [TopologicalSpace S₁] [TopologicalSpace S₂]
    (f : S₁ → S₂) (x : S₁) :
    ContinuousAt f x ↔ ∀ (F : Filter S₁), F ≤ 𝓝 x → Tendsto f F (𝓝 (f x)) := by
  constructor
  · intro h F hF
    exact Tendsto.mono_left h hF
  · intro h
    exact h (𝓝 x) (le_refl _)