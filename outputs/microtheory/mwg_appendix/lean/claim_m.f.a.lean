import Mathlib

open Filter Topology
open Topology

theorem Claim_M_F_a {X : Type*} [TopologicalSpace X] [FirstCountableTopology X]
    (A : Set X) :
    IsClosed A ↔ ∀ (x : X) (u : ℕ → X), (∀ n, u n ∈ A) → Filter.Tendsto u atTop (𝓝 x) → x ∈ A := by
  constructor
  · intro hA x u hu hlim
    exact hA.mem_of_tendsto hlim (Filter.Eventually.of_forall hu)
  · intro h
    rw [← isSeqClosed_iff_isClosed]
    intro u x hu hlim
    exact h x u hu hlim