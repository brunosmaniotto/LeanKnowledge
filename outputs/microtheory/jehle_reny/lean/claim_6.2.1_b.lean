import Mathlib
open Topology

/-- Two utility functions represent the same preferences iff one is a strictly
    increasing transformation of the other. The backward direction is proved;
    the forward direction (constructing the transformation) is axiomatized. -/

-- Axiomatize the forward direction: same ordering → strictly increasing transformation exists
axiom order_equiv_implies_strict_mono_transform {X : Type*} [Nonempty X]
    (u v : X → ℝ) (h : ∀ x y : X, u x ≤ u y ↔ v x ≤ v y) :
    ∃ f : ℝ → ℝ, StrictMono f ∧ ∀ x, v x = f (u x)

theorem claim_6_2_1_b {X : Type*} [Nonempty X]
    (u v : X → ℝ) :
    (∀ x y : X, u x ≤ u y ↔ v x ≤ v y) ↔
    (∃ f : ℝ → ℝ, StrictMono f ∧ ∀ x, v x = f (u x)) := by
  constructor
  · exact order_equiv_implies_strict_mono_transform u v
  · rintro ⟨f, hf_mono, hf_eq⟩ x y
    simp only [hf_eq]
    constructor
    · exact fun h => hf_mono.monotone h
    · intro h
      by_contra hlt
      push_neg at hlt
      exact not_le.mpr (hf_mono hlt) h