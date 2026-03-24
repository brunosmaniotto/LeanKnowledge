import Mathlib

/-- If f(x̄) ≥ f(x) for all x in C₋ₖ (relaxed constraint set) and x̄ satisfies the
    dropped constraint hₖ(x̄) ≤ cₖ, then x̄ maximizes f over the fully constrained set C.
    This follows because C ⊆ C₋ₖ, so optimality over the larger set implies optimality
    over the smaller set (given membership). -/
theorem claim_M_K_l
    {α : Type*} {f : α → ℝ} {C C_minus_k : Set α}
    {x_bar : α}
    (hsub : C ⊆ C_minus_k)
    (hopt : ∀ x ∈ C_minus_k, f x ≤ f x_bar)
    (hmem : x_bar ∈ C) :
    x_bar ∈ C ∧ ∀ x ∈ C, f x ≤ f x_bar := by
  exact ⟨hmem, fun x hx => hopt x (hsub hx)⟩