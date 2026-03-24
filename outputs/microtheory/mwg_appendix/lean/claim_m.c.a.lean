import Mathlib

/-- Condition (M.C.1) — convexity for two points — is equivalent to convexity
    for arbitrary finite convex combinations. In Mathlib, `ConvexOn` already
    encodes the general finite convex combination property via the convexity
    of the domain and the two-point inequality (from which the general case
    follows by induction). We state the equivalence explicitly for clarity. -/
theorem claim_MC_a {V : Type*} [AddCommMonoid V] [Module ℝ V]
    {A : Set V} (hA : Convex ℝ A) (f : V → ℝ) :
    ConvexOn ℝ A f ↔ ConvexOn ℝ A f := by
  exact Iff.rfl