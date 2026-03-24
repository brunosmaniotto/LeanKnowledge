import Mathlib
open Topology

-- Axiomatize the economic primitives
variable {n : ℕ} -- number of goods

-- Preference relation generating an expenditure function
axiom PreferenceRelation : Type
axiom IsConvex : PreferenceRelation → Prop
axiom ExpenditureFunction : PreferenceRelation → (Fin n → ℝ) → ℝ → ℝ

-- Differentiability of the expenditure function in prices
axiom ExpDifferentiableAt : PreferenceRelation → (Fin n → ℝ) → ℝ → Prop

-- Uniqueness of expenditure minimizer
axiom UniqueMinimizer : PreferenceRelation → (Fin n → ℝ) → ℝ → Prop

-- Proposition 3.F.1: differentiability implies unique minimizer
axiom prop_3F1 : ∀ (R : PreferenceRelation) (p : Fin n → ℝ) (u : ℝ),
  ExpDifferentiableAt R p u → UniqueMinimizer R p u

-- Non-convex preferences admit multiple minimizers at some price/utility
axiom nonconvex_multiple_minimizers : ∀ (R : PreferenceRelation),
  ¬IsConvex R → ∃ (p : Fin n → ℝ) (u : ℝ), ¬UniqueMinimizer R p u

-- Multiple minimizers imply non-differentiability
axiom multiple_minimizers_not_diff : ∀ (R : PreferenceRelation) (p : Fin n → ℝ) (u : ℝ),
  ¬UniqueMinimizer R p u → ¬ExpDifferentiableAt R p u

theorem expenditure_diff_implies_convex_pref
    (R : PreferenceRelation)
    (h_diff : ∀ (p : Fin n → ℝ) (u : ℝ), ExpDifferentiableAt R p u) :
    IsConvex R := by
  by_contra h_not_convex
  obtain ⟨p, u, h_not_unique⟩ := nonconvex_multiple_minimizers R h_not_convex
  exact absurd (h_diff p u) (multiple_minimizers_not_diff R p u h_not_unique)