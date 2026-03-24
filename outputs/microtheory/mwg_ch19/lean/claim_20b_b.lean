import Mathlib

open BigOperators Finset
open Topology

theorem Claim_20B_b_stationarity :
    ∀ (δ : ℝ) (hδ : 0 < δ) (hδ1 : δ < 1),
    (∀ (T s : ℕ), δ ^ (T + s) = δ ^ T * δ ^ s) ∧
    (∃ (d : ℕ → ℝ),
      d 0 = 1 ∧ d 1 = 1 ∧ d 2 = (1 : ℝ) / 4 ∧
      d 2 / d 1 ≠ d 1 / d 0) := by
  intro δ hδ hδ1
  constructor
  · intro T s
    exact pow_add δ T s
  · exact ⟨fun n => if n = 0 then 1 else if n = 1 then 1 else 1/4,
      by norm_num, by norm_num, by norm_num, by norm_num⟩