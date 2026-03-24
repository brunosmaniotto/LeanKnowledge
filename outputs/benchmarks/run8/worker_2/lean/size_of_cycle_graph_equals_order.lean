import Mathlib

-- Axiomatized sub-lemmas (provided as givens)

/--
Axiom 1: A cycle graph on `n` vertices (where `n ≥ 3`) is 2-regular.
This means every vertex has a degree of 2.
-/
axiom cycleGraph_is_two_regular {n : ℕ} (hn : 3 ≤ n) :
  (SimpleGraph.cycleGraph n).IsRegularOfDegree 2

/--
Axiom 2: For any 2-regular graph on a finite vertex set, the number of edges (its size)
is equal to the number of vertices (its order).
-/
axiom card_edges_of_two_regular_graph {V : Type*} [Fintype V] {G : SimpleGraph V}
    [DecidableRel G.Adj] (h_reg : G.IsRegularOfDegree 2) :
  G.edgeFinset.card = Fintype.card V

-- Main theorem proving that the size of a cycle graph equals its order.

theorem cycleGraph_size_eq_order {n : ℕ} (hn : 3 ≤ n) : (SimpleGraph.cycleGraph n).edgeFinset.card = n := by
  -- By the first axiom, a cycle graph with at least 3 vertices is 2-regular.
  have h_reg : (SimpleGraph.cycleGraph n).IsRegularOfDegree 2 :=
    cycleGraph_is_two_regular hn

  -- By the second axiom, any 2-regular graph's edge count equals its vertex count.
  -- The vertex set for `SimpleGraph.cycleGraph n` is `Fin n`.
  -- Lean infers the types `V := Fin n` and `G := SimpleGraph.cycleGraph n` automatically.
  have h_card_eq := card_edges_of_two_regular_graph h_reg
  -- At this point, `h_card_eq` is `(SimpleGraph.cycleGraph n).edgeFinset.card = Fintype.card (Fin n)`.

  -- The number of elements in the type `Fin n` is `n`. We use `Fintype.card_fin` to rewrite.
  rw [Fintype.card_fin] at h_card_eq
  -- Now, `h_card_eq` is `(SimpleGraph.cycleGraph n).edgeFinset.card = n`, which is our goal.

  exact h_card_eq