import Mathlib
open Topology

theorem claim_8_deductible
    {L : ℕ}
    (u' : ℝ → ℝ)
    (w p : ℝ)
    (B : Fin (L + 1) → ℝ)
    (hu'_anti : StrictAnti u')
    (h_foc : StrictMono fun l : Fin (L + 1) =>
      u' (w - p + B l - (l.val : ℝ)))
    : StrictMono fun l : Fin (L + 1) => (l.val : ℝ) - B l := by
  intro i j hij
  have hfoc : u' (w - p + B i - ↑↑i) < u' (w - p + B j - ↑↑j) := h_foc hij
  by_contra habs
  push_neg at habs
  have hc : w - p + B i - (↑↑i : ℝ) ≤ w - p + B j - (↑↑j : ℝ) := by linarith
  rcases hc.lt_or_eq with h | h
  · linarith [hu'_anti h]
  · rw [h] at hfoc; exact lt_irrefl _ hfoc