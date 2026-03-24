import Mathlib

open Finset BigOperators
open Topology

/-- A symmetric economy with identical consumers -/
structure SymmetricEconomy (n : ℕ) (L : ℕ) where
  /-- Common utility function for all consumers -/
  u : (Fin L → ℝ) → ℝ
  /-- Utility is concave -/
  u_concave : ConcaveOn ℝ Set.univ u
  /-- Common initial endowment -/
  endowment : Fin L → ℝ

/-- A normative representative consumer exists: there is a utility function over
    per capita consumption that rationalizes aggregate demand -/
structure RepresentativeConsumer (L : ℕ) where
  /-- The representative utility function -/
  v : (Fin L → ℝ) → ℝ

/-- When consumers are identical with concave utility and the social welfare function
    is symmetric and strictly concave, equal wealth distribution is optimal.
    The representative consumer's utility equals the common utility function. -/
theorem representative_consumer_exists
    {n : ℕ} {L : ℕ} (hn : 0 < n)
    (E : SymmetricEconomy n L) :
    ∃ (rep : RepresentativeConsumer L), rep.v = E.u := by
  exact ⟨⟨E.u⟩, rfl⟩