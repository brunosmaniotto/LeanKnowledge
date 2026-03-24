import Mathlib

/-- Equal-division allocation: every consumer gets the same bundle (1/I) · e -/
theorem equal_division_envy_free
    {I : Type*} [Fintype I] [Nonempty I]
    {L : ℕ}
    (strictPref : I → (Fin L → ℝ) → (Fin L → ℝ) → Prop)
    (irrefl : ∀ i x, ¬ strictPref i x x)
    (e : Fin L → ℝ)
    (x : I → Fin L → ℝ)
    (equal_div : ∀ i : I, x i = (fun l => e l / Fintype.card I))
    : ∀ i j : I, ¬ strictPref i (x j) (x i) := by
  intro i j
  rw [equal_div i, equal_div j]
  exact irrefl i _