import Mathlib

open Finset BigOperators
open Topology
open BigOperators

noncomputable def expenditure {L : ℕ} (p x : Fin L → ℝ) : ℝ := ∑ i, p i * x i

theorem Proposition_3E1 {L : ℕ} (u : (Fin L → ℝ) → ℝ) (p : Fin L → ℝ) (w : ℝ)
    (x_star : Fin L → ℝ)
    (h_ump : ∀ x', (∀ i, x' i ≥ 0) → expenditure p x' ≤ w → u x' ≤ u x_star)
    (h_walras : expenditure p x_star = w)
    (h_lns : ∀ x', (∀ i, x' i ≥ 0) → u x' ≥ u x_star →
      expenditure p x' < w →
      ∃ x'', (∀ i, x'' i ≥ 0) ∧ u x'' > u x_star ∧ expenditure p x'' ≤ w) :
    (∀ x', (∀ i, x' i ≥ 0) → u x' ≥ u x_star → expenditure p x' ≥ w) ∧
    expenditure p x_star = w := by
  exact ⟨fun x' hnn hu => by
    by_contra h
    push_neg at h
    obtain ⟨x'', _, hu'', he''⟩ := h_lns x' hnn hu h
    linarith [h_ump x'' ‹_› he''], h_walras⟩