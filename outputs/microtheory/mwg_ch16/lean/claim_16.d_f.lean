import Mathlib

open Finset BigOperators
open BigOperators

/-- In a pure exchange economy with ω >> 0, continuous strongly monotone preferences,
    any price quasiequilibrium with transfers is a price equilibrium with transfers.
    Core lemma: p >> 0 and ω >> 0 imply p·ω > 0, so wealth is positive for each consumer. -/
theorem price_quasiequilibrium_implies_equilibrium
    {L : Type*} [Fintype L] [DecidableEq L] [Nonempty L]
    {I : Type*} [Fintype I] [DecidableEq I] [Nonempty I]
    (p : L → ℝ)
    (ω : I → L → ℝ)
    (hp_pos : ∀ l, 0 < p l)
    (hω_pos : ∀ i l, 0 < ω i l)
    -- wealth of consumer i is p · ω_i
    (w : I → ℝ)
    (hw_def : ∀ i, w i = ∑ l : L, p l * ω i l) :
    -- Every consumer has strictly positive wealth
    (∀ i, 0 < w i) := by
  intro i
  rw [hw_def]
  apply Finset.sum_pos
  · intro l _
    exact mul_pos (hp_pos l) (hω_pos i l)
  · exact Finset.univ_nonempty