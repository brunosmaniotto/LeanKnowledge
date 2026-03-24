import Mathlib

open Finset

variable {V : Type*} [Fintype V] [DecidableEq V] (G : SimpleGraph V) [DecidableRel G.Adj]

theorem traversable_iff_connected_and_at_most_two_odd (hG : G.Connected) :
    (∃ (u v : V) (p : G.Walk u v), p.IsEulerian) ↔ Fintype.card {v : V | Odd (G.degree v)} ≤ 2 := by
  constructor
  · intro h
    rcases h with ⟨u, v, p, hp⟩
    have h_card := hp.card_odd_degree
    cases' h_card with h0 h2
    · have : Fintype.card {v | Odd (G.degree v)} = 0 := h0
      linarith
    · have : Fintype.card {v | Odd (G.degree v)} = 2 := h2
      linarith
  · intro h
    sorry