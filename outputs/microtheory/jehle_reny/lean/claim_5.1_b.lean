import Mathlib
open Topology

theorem Claim_5_1_b
    {n : ℕ} (hn : 0 < n)
    {Allocation : Type*}
    (u : Fin n → Allocation → ℝ)
    (feasible : Set Allocation)
    (x : Allocation)
    (hx : x ∈ feasible) :
    (¬ ∃ x' ∈ feasible, (∀ i, u i x ≤ u i x') ∧ (∃ i, u i x < u i x')) ↔
    (∀ x' ∈ feasible, (∃ i, u i x < u i x') → (∃ j, u j x' < u j x)) := by
  constructor
  · intro hPE x' hx'f hbetter
    by_contra h
    push_neg at h
    exact hPE ⟨x', hx'f, h, hbetter⟩
  · intro h ⟨x', hx'f, hall, hsome⟩
    obtain ⟨j, hj⟩ := h x' hx'f hsome
    linarith [hall j]