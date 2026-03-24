import Mathlib
open Topology

/-- The indirect utility function v(p, w) gives the utility value of the
    utility maximization problem (UMP) by evaluating u at any optimal
    bundle x* ∈ x(p, w). -/
noncomputable def indirectUtility
    {n : ℕ}
    (u : (Fin n → ℝ) → ℝ)
    (x : (Fin n → ℝ) → ℝ → Set (Fin n → ℝ))
    (p : Fin n → ℝ)
    (w : ℝ)
    (hne : (x p w).Nonempty) : ℝ :=
  u hne.some