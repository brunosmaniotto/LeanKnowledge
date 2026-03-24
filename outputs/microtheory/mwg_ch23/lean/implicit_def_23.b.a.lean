import Mathlib

/-- An incomplete information environment for mechanism design.
    Each agent i has a type space Θᵢ, a utility function uᵢ(·, θᵢ),
    and there is a common prior density φ over type profiles. -/
structure IncompleteInfoEnvironment (I : Type*) (Outcome : Type*) where
  /-- Type space for each agent -/
  TypeSpace : I → Type*
  /-- Common prior density over type profiles -/
  density : ((i : I) → TypeSpace i) → NNReal
  /-- Utility function for agent i, depending on outcome and their own type -/
  utility : (i : I) → Outcome → TypeSpace i → ℝ