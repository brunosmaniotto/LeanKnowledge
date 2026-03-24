import Mathlib

/-- A necessary condition for a normative representative consumer:
    the Scitovsky set A is contained in the "at least as good as" set B.
    We model this abstractly: A is defined by a distributional property,
    and any bundle satisfying that property must satisfy u(x) ≥ u(x̄),
    which defines membership in B. -/
theorem claim_4D_g
    {X : Type*}
    (u : X → ℝ)
    (x_bar : X)
    (A B : Set X)
    (hB : B = {x | u x ≥ u x_bar})
    (h_welfare : ∀ x ∈ A, u x ≥ u x_bar) :
    A ⊆ B := by
  rw [hB]
  intro x hx
  exact h_welfare x hx