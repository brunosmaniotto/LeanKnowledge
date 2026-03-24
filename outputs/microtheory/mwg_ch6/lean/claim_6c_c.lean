import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem st_petersburg_menger_paradox
    (u : ℝ → ℝ)
    (h_unbounded : ∀ M : ℝ, ∃ x : ℝ, u x > M) :
    ∀ B : ℝ, ∃ (x : ℕ → ℝ) (n : ℕ),
      ∑ m ∈ range n, u (x m) * (1 / (2 : ℝ) ^ (m + 1)) > B := by
  intro B
  obtain ⟨y, hy⟩ := h_unbounded (2 * B)
  refine ⟨fun _ => y, 1, ?_⟩
  simp [Finset.sum_range_one]
  linarith