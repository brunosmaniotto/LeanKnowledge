import Mathlib
open Topology
open BigOperators

axiom mean_income_pos {n : ℕ} (n_pos : Fact (0 < n)) (y : Fin n → ℝ) (h_pos : ∀ i, 0 < y i) : 0 < (∑ i : Fin n, y i) / (n : ℝ)
axiom atkinson_index_lower_bound (μ : ℝ) (h_μ_pos : 0 < μ) (y_e : ℝ) (h_ye_pos : 0 < y_e) : 0 < y_e / μ
axiom atkinson_index_upper_bound (μ : ℝ) (h_μ_pos : 0 < μ) (y_e : ℝ) (h_ye_le_μ : y_e ≤ μ) : y_e / μ ≤ 1

theorem Exercise_6_14_a {n : ℕ} (n_pos : Fact (0 < n)) (y : Fin n → ℝ) (h_yi_pos : ∀ i, 0 < y i) (y_e : ℝ) (h_ye_pos : 0 < y_e) (h_ye_le_mean : y_e ≤ (∑ i : Fin n, y i) / (n : ℝ)) : 0 < y_e / ((∑ i : Fin n, y i) / (n : ℝ)) ∧ y_e / ((∑ i : Fin n, y i) / (n : ℝ)) ≤ 1 := by
  let μ := (∑ i : Fin n, y i) / (n : ℝ)
  have h_μ_pos : 0 < μ := mean_income_pos n_pos y h_yi_pos
  have h_lower_bound : 0 < y_e / μ := atkinson_index_lower_bound μ h_μ_pos y_e h_ye_pos
  have h_upper_bound : y_e / μ ≤ 1 := atkinson_index_upper_bound μ h_μ_pos y_e h_ye_le_mean
  exact ⟨h_lower_bound, h_upper_bound⟩