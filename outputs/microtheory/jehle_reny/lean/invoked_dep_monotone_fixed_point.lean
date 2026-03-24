import Mathlib

/-- A non-decreasing function mapping [a, b] into itself has a fixed point
    (1-dimensional Knaster–Tarski). No continuity required. -/
theorem Invoked_Dep_Monotone_Fixed_Point
    {a b : ℝ} (hab : a ≤ b)
    (f : ↥(Set.Icc a b) → ↥(Set.Icc a b))
    (hf : Monotone f) :
    ∃ x : ↥(Set.Icc a b), f x = x := by
  haveI : Fact (a ≤ b) := ⟨hab⟩
  let F : ↥(Set.Icc a b) →o ↥(Set.Icc a b) := ⟨f, hf⟩
  exact ⟨F.lfp, F.map_lfp⟩