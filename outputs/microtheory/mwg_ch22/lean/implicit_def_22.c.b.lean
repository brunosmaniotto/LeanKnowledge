import Mathlib

/-- A social optimum for a social welfare function W over a utility possibility set U.
    A utility vector u* ∈ U is a social optimum if it maximizes W over U. -/
structure SocialOptimum (I : Type*) [Fintype I] (W : (I → ℝ) → ℝ) (U : Set (I → ℝ)) where
  /-- The optimal utility vector -/
  utilities : I → ℝ
  /-- The optimal vector lies in the utility possibility set -/
  mem_set : utilities ∈ U
  /-- The optimal vector maximizes W over U -/
  is_max : ∀ v ∈ U, W v ≤ W utilities

/-- A constrained social optimum is a social optimum where the utility possibility set
    reflects second-best constraints (i.e., additional incentive or informational constraints
    beyond simple feasibility). -/
structure ConstrainedSocialOptimum (I : Type*) [Fintype I] (W : (I → ℝ) → ℝ)
    (U_full : Set (I → ℝ)) (U_constrained : Set (I → ℝ)) extends SocialOptimum I W U_constrained where
  /-- The constrained set is a subset of the full utility possibility set -/
  subset_full : U_constrained ⊆ U_full