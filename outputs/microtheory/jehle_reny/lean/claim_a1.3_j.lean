import Mathlib

open Metric Set
open Topology

theorem claim_A1_3_j {n : ℕ} (S : Set (EuclideanSpace ℝ (Fin n))) :
    Bornology.IsBounded S ↔ ∃ ε : ℝ, 0 < ε ∧ S ⊆ closedBall 0 ε := by
  constructor
  · intro hb
    obtain ⟨r, hr⟩ := isBounded_iff_subset_closedBall (0 : EuclideanSpace ℝ (Fin n)) |>.mp hb
    exact ⟨max r 1, by positivity, hr.trans (closedBall_subset_closedBall (le_max_left r 1))⟩
  · rintro ⟨ε, -, hS⟩
    exact isBounded_closedBall.subset hS