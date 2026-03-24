import Mathlib
open Topology

/-- The private values assumption: each agent's utility depends only on their own type.
    In the general case, utility would be u_i(x, θ) where θ is the full type profile,
    but under private values, u_i(x, θ_i) depends only on agent i's own type. -/
structure PrivateValuesModel (Agent : Type*) (Outcome : Type*) (TypeSpace : Agent → Type*) where
  /-- Each agent's utility depends only on the outcome and their own type -/
  utility : (i : Agent) → Outcome → TypeSpace i → ℝ