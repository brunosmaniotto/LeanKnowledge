import Mathlib
open Topology

theorem Claim_1_3_a
    {X : Type*} (u : X → ℝ) (pref : X → X → Prop)
    (B : Set X)
    (h_rep : ∀ x y : X, pref x y ↔ u x ≥ u y) :
    ∀ x_star ∈ B,
      (∀ x ∈ B, u x_star ≥ u x) ↔ (∀ x ∈ B, pref x_star x) := by
  intro x_star _
  constructor
  · intro h x hx
    exact (h_rep x_star x).mpr (h x hx)
  · intro h x hx
    exact (h_rep x_star x).mp (h x hx)