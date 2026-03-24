import Mathlib
open Topology

theorem claim_2_4_3_b (u : ℝ → ℝ) (s : Set ℝ) (hs : Convex ℝ s) :
    (StrictConcaveOn ℝ s u ↔
      ∀ ⦃x⦄, x ∈ s → ∀ ⦃y⦄, y ∈ s → x ≠ y →
        ∀ ⦃a b : ℝ⦄, 0 < a → 0 < b → a + b = 1 →
          a • u x + b • u y < u (a • x + b • y)) ∧
    ((ConcaveOn ℝ s u ∧ ConvexOn ℝ s u) ↔
      ∀ ⦃x⦄, x ∈ s → ∀ ⦃y⦄, y ∈ s →
        ∀ ⦃a b : ℝ⦄, 0 ≤ a → 0 ≤ b → a + b = 1 →
          u (a • x + b • y) = a • u x + b • u y) ∧
    (StrictConvexOn ℝ s u ↔
      ∀ ⦃x⦄, x ∈ s → ∀ ⦃y⦄, y ∈ s → x ≠ y →
        ∀ ⦃a b : ℝ⦄, 0 < a → 0 < b → a + b = 1 →
          u (a • x + b • y) < a • u x + b • u y) := by
  refine ⟨⟨fun ⟨_, h⟩ => h, fun h => ⟨hs, h⟩⟩, ?_, ⟨fun ⟨_, h⟩ => h, fun h => ⟨hs, h⟩⟩⟩
  constructor
  · rintro ⟨⟨-, hle⟩, ⟨-, hge⟩⟩ x hxs y hys a b ha hb hab
    exact le_antisymm (hge hxs hys ha hb hab) (hle hxs hys ha hb hab)
  · intro h
    exact ⟨⟨hs, fun x hxs y hys a b ha hb hab =>
        le_of_eq (h hxs hys ha hb hab).symm⟩,
      ⟨hs, fun x hxs y hys a b ha hb hab =>
        le_of_eq (h hxs hys ha hb hab)⟩⟩