import Mathlib
open Topology

theorem convex_preferences_require_convex_set
    {V : Type*} [AddCommMonoid V] [Module ℝ V]
    (X : Set V)
    (h : ∀ (R : V → V → Prop),
      (∀ x ∈ X, ∀ y ∈ X, R x y) →
      ∀ x ∈ X, Convex ℝ {y ∈ X | R y x}) :
    Convex ℝ X := by
  by_cases hne : X.Nonempty
  · obtain ⟨x, hx⟩ := hne
    have hR := h (fun _ _ => True) (fun _ _ _ _ => trivial) x hx
    have heq : {y ∈ X | True} = X := by ext; simp
    rw [← heq]
    exact hR
  · rw [Set.not_nonempty_iff_eq_empty] at hne
    rw [hne]
    exact convex_empty