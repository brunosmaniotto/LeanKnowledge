import Mathlib.Tactic

variable {G : Type} [Group G]

theorem Group.latin_square_property (a b : G) : (∃! g, a * g = b) ∧ (∃! h, h * a = b) := by
  constructor
  · refine ⟨a⁻¹ * b, ?_, ?_⟩
    · group
    · intro g hg
      calc
        g = a⁻¹ * (a * g) := by group
        _ = a⁻¹ * b := by rw [hg]
  · refine ⟨b * a⁻¹, ?_, ?_⟩
    · group
    · intro h hh
      calc
        h = h * 1 := by group
        _ = h * (a * a⁻¹) := by group
        _ = (h * a) * a⁻¹ := by group
        _ = b * a⁻¹ := by rw [hh]