import Mathlib

open ConjAct
open MulAction

variable (G : Type _) [Group G]

theorem orbit_identity_eq_singleton : orbit (ConjAct G) (1 : G) = {1} := by
  ext x
  constructor
  · intro hx
    rcases hx with ⟨g, rfl⟩
    simp [smul_def]
  · intro hx
    have : x = (1 : G) := by simpa using hx
    subst this
    exact ⟨1, by simp [smul_def]⟩