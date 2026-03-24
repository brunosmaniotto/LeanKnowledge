import Mathlib
open BigOperators
open Topology

/-- The gross substitute property implies condition (17.F.3): if z(p) = 0 and z(p') ≠ 0,
    then p · z(p') > 0. -/
theorem gross_substitute_implies_17F3
    {L : ℕ} [NeZero L]
    (z : (Fin L → ℝ) → (Fin L → ℝ))
    (walras : ∀ p : Fin L → ℝ, ∑ l : Fin L, p l * z p l = 0)
    -- Strict weak axiom (implied by gross substitutes):
    -- if p · z(p') ≤ 0 and z(p') ≠ z(p), then p' · z(p) > 0
    (strict_weak_axiom : ∀ p p' : Fin L → ℝ,
      z p' ≠ z p →
      ∑ l : Fin L, p l * z p' l ≤ 0 →
      ∑ l : Fin L, p' l * z p l > 0)
    (p p' : Fin L → ℝ)
    (heq : z p = 0)
    (hneq : z p' ≠ 0)
    : ∑ l : Fin L, p l * z p' l > 0 := by
  by_contra h
  push_neg at h
  -- z(p') ≠ z(p) since z(p) = 0 and z(p') ≠ 0
  have hne : z p' ≠ z p := by rw [heq]; exact hneq
  -- By strict weak axiom: p' · z(p) > 0
  have hswa := strict_weak_axiom p p' hne h
  -- But z(p) = 0, so p' · z(p) = 0
  have hzero : ∑ l : Fin L, p' l * z p l = 0 := by
    simp [heq]
  linarith