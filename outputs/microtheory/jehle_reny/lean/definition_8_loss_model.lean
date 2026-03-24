import Mathlib

open BigOperators Finset

/-- The moral hazard insurance model: a single insurer and consumer,
    `L + 1` loss levels `l ∈ Fin (L+1)` (where `0` = no accident),
    two effort levels (low = `0`, high = `1`), and a probability
    distribution `π e l > 0` over losses for each effort level
    that sums to one. -/
structure MoralHazardInsuranceModel (L : ℕ) where
  /-- Probability of loss level `l` given effort level `e`. -/
  π : Fin 2 → Fin (L + 1) → ℝ
  /-- Every loss probability is strictly positive. -/
  prob_pos : ∀ (e : Fin 2) (l : Fin (L + 1)), 0 < π e l
  /-- For each effort level, the probabilities sum to one. -/
  prob_sum : ∀ (e : Fin 2), ∑ l : Fin (L + 1), π e l = 1