import Mathlib

open Finset
open BigOperators

theorem regular_graph_size {V : Type*} [Fintype V] [DecidableEq V] 
    (G : SimpleGraph V) [DecidableRel G.Adj] (r : ℕ) (h : ∀ v, G.degree v = r) :
    G.edgeFinset.card = (Fintype.card V * r) / 2 := by
  have handshake := G.sum_degrees_eq_twice_card_edges
  have total_deg : ∑ v : V, G.degree v = Fintype.card V * r := by
    simp [h, Finset.sum_const, Finset.card_univ]
  have h_eq : 2 * G.edgeFinset.card = Fintype.card V * r := by
    linarith [handshake, total_deg]
  calc
    G.edgeFinset.card = (2 * G.edgeFinset.card) / 2 := by
      rw [Nat.mul_div_cancel_left _ (by norm_num)]
    _ = (Fintype.card V * r) / 2 := by rw [h_eq]