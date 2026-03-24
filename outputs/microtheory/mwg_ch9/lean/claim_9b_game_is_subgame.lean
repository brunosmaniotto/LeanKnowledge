import Mathlib

/-- An extensive-form game tree with nodes of type α -/
structure GameTree (α : Type*) where
  nodes : Set α
  root : α
  root_mem : root ∈ nodes
  successors : α → Set α
  successors_closed : ∀ x ∈ nodes, successors x ⊆ nodes

/-- A subgame rooted at `r` over node set `S` (Definition 9.B.1) -/
structure IsSubgame {α : Type*} (G : GameTree α) (S : Set α) (r : α) : Prop where
  subRoot_mem : r ∈ G.nodes
  subNodes_subset : S ⊆ G.nodes
  contains_root : r ∈ S
  successor_closed : ∀ x ∈ S, G.successors x ⊆ S

/-- The entire game is a subgame of itself (Claim 9.B) -/
theorem game_is_subgame {α : Type*} (G : GameTree α) : IsSubgame G G.nodes G.root where
  subRoot_mem := G.root_mem
  subNodes_subset := Set.Subset.refl G.nodes
  contains_root := G.root_mem
  successor_closed := G.successors_closed