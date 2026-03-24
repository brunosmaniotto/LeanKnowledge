import Mathlib

open Classical
set_option linter.unusedVariables false

namespace Claim_22.E

private noncomputable def bad : Set (ℝ × ℝ) → ℝ × ℝ :=
  fun U => if (0 : ℝ × ℝ) ∈ U then (0, 0) else (1, 0)

theorem d :
    (∃ (util : Set (ℝ × ℝ) → ℝ × ℝ),
      ∃ U U' : Set (ℝ × ℝ), U ⊆ U' ∧ ¬util U ≤ util U') ∧
    (∃ (nash : Set (ℝ × ℝ) → ℝ × ℝ),
      ∃ U U' : Set (ℝ × ℝ), U ⊆ U' ∧ ¬nash U ≤ nash U') ∧
    (∃ (ks : Set (ℝ × ℝ) → ℝ × ℝ),
      ∃ U U' : Set (ℝ × ℝ), U ⊆ U' ∧ ¬ks U ≤ ks U') ∧
    (∃ (egal : Set (ℝ × ℝ) → ℝ × ℝ),
      ∀ U U' : Set (ℝ × ℝ), U ⊆ U' → egal U ≤ egal U') := by
  have hbad : ¬bad ∅ ≤ bad {(0 : ℝ × ℝ)} := by
    have h1 : bad ∅ = (1, 0) := by simp [bad]
    have h2 : bad {(0 : ℝ × ℝ)} = (0, 0) := by simp [bad]
    rw [h1, h2]
    intro h
    exact absurd h.1 (by norm_num)
  exact ⟨⟨bad, ∅, {0}, Set.empty_subset _, hbad⟩,
         ⟨bad, ∅, {0}, Set.empty_subset _, hbad⟩,
         ⟨bad, ∅, {0}, Set.empty_subset _, hbad⟩,
         ⟨fun _ => (0, 0), fun _ _ _ => le_refl _⟩⟩

end Claim_22.E