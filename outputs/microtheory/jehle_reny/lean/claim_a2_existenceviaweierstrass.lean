import Mathlib

open Set Topology

/-- If the objective function f is real-valued and continuous, and the constraint set
    defined by the constraint equations is compact, then by the Weierstrass theorem
    (Theorem A1.10), optima of f over the constraint set exist. -/
theorem claim_A2_ExistenceViaWeierstrass
    {α : Type*} [TopologicalSpace α]
    {S : Set α} {f : α → ℝ}
    (hS_compact : IsCompact S)
    (hS_nonempty : S.Nonempty)
    (hf_cont : ContinuousOn f S) :
    (∃ x ∈ S, ∀ y ∈ S, f y ≤ f x) ∧
    (∃ x ∈ S, ∀ y ∈ S, f x ≤ f y) := by
  constructor
  · obtain ⟨x, hxS, hx⟩ := hS_compact.exists_isMaxOn hS_nonempty hf_cont
    exact ⟨x, hxS, fun y hy => hx hy⟩
  · obtain ⟨x, hxS, hx⟩ := hS_compact.exists_isMinOn hS_nonempty hf_cont
    exact ⟨x, hxS, fun y hy => hx hy⟩