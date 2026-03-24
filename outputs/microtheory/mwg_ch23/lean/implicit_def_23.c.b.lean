import Mathlib

variable {Agent : Type*} {X : Type*} {Θ : Agent → Type*}

/-- The lower contour set of alternative `x` for agent `i` with type `θ_i`:
    all alternatives `z` that agent `i` weakly disprefers to `x`. -/
def lowerContourSet
    (u : (i : Agent) → X → Θ i → ℝ)
    (i : Agent)
    (x : X)
    (θ_i : Θ i) : Set X :=
  {z : X | u i x θ_i ≥ u i z θ_i}