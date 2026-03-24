import Mathlib

/-- An equal-treatment allocation is an allocation in which consumers of the same type
    get the same consumption bundles. In a replica economy, consumer types are indexed
    by some base set, and each type has multiple copies. -/
structure EqualTreatmentAllocation
    (Type_ : Type*) (Good : Type*) (numReplicas : ℕ)
    [DecidableEq Type_] where
  /-- The allocation assigns a consumption bundle to each (type, replica) pair. -/
  allocation : Type_ → Fin numReplicas → Good
  /-- All replicas of the same type receive the same bundle. -/
  equal_treatment : ∀ (t : Type_) (r₁ r₂ : Fin numReplicas),
    allocation t r₁ = allocation t r₂