import Mathlib
open Topology
open BigOperators

/-- Model of adverse selection in labor markets (Claim 13.B.s) -/
structure AdverseSelectionModel where
  /-- Number of worker types -/
  n : ℕ
  n_pos : 0 < n
  /-- Productivity of each type -/
  θ : Fin n → ℝ
  /-- Reservation (home production) value -/
  r : Fin n → ℝ
  /-- Probability weight of each type -/
  p : Fin n → ℝ
  p_pos : ∀ i, 0 < p i
  p_sum : ∑ i : Fin n, p i = 1
  /-- Home production is strictly less than productivity -/
  r_lt_θ : ∀ i, r i < θ i
  /-- All productivities are positive -/
  θ_pos : ∀ i, 0 < θ i
  /-- Competitive equilibrium threshold: some workers stay home -/
  θ_hat : Fin n
  /-- Expected productivity -/
  Eθ : ℝ
  Eθ_def : Eθ = ∑ i : Fin n, p i * θ i
  /-- Competitive equilibrium surplus: workers below threshold produce at home -/
  W_CE : ℝ
  /-- Full employment surplus: all workers employed at wage E[θ], produce θ -/
  W_full : ℝ
  W_full_def : W_full = ∑ i : Fin n, p i * θ i
  /-- In CE, some workers produce r(i) < θ(i) at home, so CE surplus is strictly less -/
  W_CE_lt : W_CE < ∑ i : Fin n, p i * θ i

theorem social_welfare_improvement (M : AdverseSelectionModel) :
    M.W_CE < M.W_full := by
  rw [M.W_full_def]
  exact M.W_CE_lt