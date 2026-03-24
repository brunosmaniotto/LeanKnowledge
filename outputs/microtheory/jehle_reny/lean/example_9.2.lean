import Mathlib
open MeasureTheory intervalIntegral
open Topology

theorem Example_9_2 (N : ℕ) (hN : 0 < N) :
    (↑N - 1 : ℝ) * ∫ x in (0:ℝ)..1, x ^ N = (↑N - 1) / (↑N + 1) ∧
    ↑N * (↑N - 1) * ∫ x in (0:ℝ)..1, x ^ (N - 1) * (1 - x) = (↑N - 1) / (↑N + 1) := by
  obtain ⟨n, rfl⟩ : ∃ n, N = n + 1 := ⟨N - 1, by omega⟩
  simp only [show n + 1 - 1 = n from by omega]
  have int_pow : ∀ m : ℕ, ∫ x in (0:ℝ)..1, x ^ m = 1 / ((↑m : ℝ) + 1) := by
    intro m
    rw [integral_pow]
    simp [one_pow, zero_pow]
  constructor
  · rw [int_pow]
    push_cast; field_simp
  · have hsplit : ∀ x : ℝ, x ^ n * (1 - x) = x ^ n - x ^ (n + 1) := fun x => by ring
    simp_rw [hsplit]
    rw [integral_sub ((continuous_pow n).intervalIntegrable 0 1)
        ((continuous_pow (n + 1)).intervalIntegrable 0 1), int_pow n, int_pow (n + 1)]
    push_cast; field_simp; ring