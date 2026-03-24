import Mathlib

/-- An allocation in the Edgeworth box is Pareto optimal if there is no other
allocation that makes at least one consumer strictly better off while keeping
both consumers at least as well off. -/
def IsParetoOptimal
    {Good : Type*} [Fintype Good]
    (ω₁ ω₂ : Good → ℝ)
    (pref₁ pref₂ : (Good → ℝ) → (Good → ℝ) → Prop)
    (x₁ x₂ : Good → ℝ) : Prop :=
  -- x is a feasible allocation in the Edgeworth box
  (∀ g, x₁ g + x₂ g = ω₁ g + ω₂ g) ∧
  (∀ g, 0 ≤ x₁ g) ∧ (∀ g, 0 ≤ x₂ g) ∧
  -- there is no other feasible allocation that Pareto dominates it
  ¬ ∃ (x₁' x₂' : Good → ℝ),
    (∀ g, x₁' g + x₂' g = ω₁ g + ω₂ g) ∧
    (∀ g, 0 ≤ x₁' g) ∧ (∀ g, 0 ≤ x₂' g) ∧
    pref₁ x₁ x₁' ∧ pref₂ x₂ x₂' ∧
    (pref₁ x₁' x₁ ∧ ¬ pref₁ x₁ x₁' ∨
     pref₂ x₂' x₂ ∧ ¬ pref₂ x₂ x₂')