import Mathlib

theorem constrained_pareto_optimum
    {Allocation : Type*}
    (Feasible : Set Allocation)
    (π u : Allocation → ℝ)
    (a : Allocation)
    (ha : a ∈ Feasible)
    (hmax_π : ∀ a' ∈ Feasible, u a' ≥ u a → π a' ≤ π a)
    (hmax_u : ∀ a' ∈ Feasible, π a' ≥ π a → u a' ≤ u a) :
    ¬∃ a' ∈ Feasible, (π a' ≥ π a ∧ u a' ≥ u a) ∧ (π a' > π a ∨ u a' > u a) := by
  intro ⟨a', ha', ⟨hπ, hu⟩, hstrict⟩
  rcases hstrict with hπgt | hugt
  · linarith [hmax_π a' ha' hu]
  · linarith [hmax_u a' ha' hπ]