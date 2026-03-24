import Mathlib
open Filter
open Topology

theorem tendsto_subseq_of_tendsto {X : Type*} [TopologicalSpace X] {x : ℕ → X} {l : X}
    (hx : Tendsto x atTop (𝓝 l)) {φ : ℕ → ℕ} (hφ : StrictMono φ) :
    Tendsto (x ∘ φ) atTop (𝓝 l) :=
  hx.comp hφ.tendsto_atTop