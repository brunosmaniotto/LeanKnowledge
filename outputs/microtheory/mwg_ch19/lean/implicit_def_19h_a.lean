import Mathlib
open Topology

/-- Information is symmetric if any two states are distinguishable by one consumer
    iff they are distinguishable by every other consumer. With symmetric information,
    all consumers share the same signal function. -/
structure SymmetricInformation (I : Type*) (S : Type*) (Signal : Type*)
    (σ : I → S → Signal) where
  /-- The common signal function shared by all consumers -/
  commonSignal : S → Signal
  /-- Each consumer's signal function equals the common one -/
  eq_common : ∀ i : I, ∀ s : S, σ i s = commonSignal s