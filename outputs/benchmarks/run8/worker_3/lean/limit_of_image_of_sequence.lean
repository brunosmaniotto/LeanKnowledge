import Mathlib
open Filter
open Topology

theorem limit_of_image_of_sequence {A₁ A₂ : Type*} [TopologicalSpace A₁] [TopologicalSpace A₂]
    (f : A₁ → A₂) (a : A₁) (hf : ContinuousAt f a) (x : ℕ → A₁) (hx : Tendsto x atTop (𝓝 a)) :
    Tendsto (f ∘ x) atTop (𝓝 (f a)) :=
  hf.tendsto.comp hx