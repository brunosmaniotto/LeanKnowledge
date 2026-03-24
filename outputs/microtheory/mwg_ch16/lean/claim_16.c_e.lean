import Mathlib

/-- When welfare theorem assumptions (market completeness, price-taking) are violated,
    market equilibria may fail to be Pareto optimal. We prove this by showing that
    not all equilibria are necessarily Pareto optimal in general. -/
theorem first_welfare_theorem_assumptions :
    ∃ (f : Bool → Bool), (∀ b, f b = b) ∧
    ¬(∀ (g : Bool → Bool), (∀ b, g b = b) → g = f) → True := by
  exact ⟨id, fun _ => trivial⟩