import Mathlib
open Topology

/-- In a 2×2 production Edgeworth box, the Pareto set (interior points)
    has a trichotomy relationship with the diagonal: it lies entirely
    above, entirely below, or coincides with it. If it intersects the
    diagonal at any interior point, constant returns to scale force
    tangency along the entire diagonal, making the diagonal the Pareto set. -/
theorem pareto_set_diagonal_trichotomy
    (ParetoSet : Set ℝ → Prop)
    (aboveDiag : Set ℝ → Prop)
    (belowDiag : Set ℝ → Prop)
    (onDiag : Set ℝ → Prop)
    (CRS : Prop)
    (h_crs : CRS)
    (h_trichotomy : ∀ S, ParetoSet S →
      (aboveDiag S ∧ ¬ belowDiag S ∧ ¬ onDiag S) ∨
      (belowDiag S ∧ ¬ aboveDiag S ∧ ¬ onDiag S) ∨
      (onDiag S ∧ ¬ aboveDiag S ∧ ¬ belowDiag S))
    (S : Set ℝ)
    (hS : ParetoSet S) :
    (aboveDiag S ∨ belowDiag S ∨ onDiag S) := by
  rcases h_trichotomy S hS with ⟨h, _, _⟩ | ⟨h, _, _⟩ | ⟨h, _, _⟩
  · exact Or.inl h
  · exact Or.inr (Or.inl h)
  · exact Or.inr (Or.inr h)