import Mathlib

theorem exists_supremum (s : Set ℝ) (hne : s.Nonempty) (hbdd : BddAbove s) : ∃ x, IsLUB s x := by
  refine ⟨sSup s, ?_⟩
  exact Real.isLUB_sSup hne hbdd