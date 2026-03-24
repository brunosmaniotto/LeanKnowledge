import Mathlib

noncomputable section
open Finset BigOperators
open Topology
open BigOperators

structure Lottery (n : ℕ) where
  prob : Fin n → ℝ
  nonneg : ∀ i, 0 ≤ prob i
  sum_one : ∑ i, prob i = 1

def EU {n : ℕ} (u : Fin n → ℝ) (L : Lottery n) : ℝ := ∑ i, L.prob i * u i