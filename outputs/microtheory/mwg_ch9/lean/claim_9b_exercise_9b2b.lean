import Mathlib
open Topology

-- Extensive form game structure
structure ExtensiveFormGame where
  nodes : Set ℕ
  root : ℕ
  root_mem : root ∈ nodes
  successors : ℕ → Set ℕ
  successors_closed : ∀ n ∈ nodes, successors n ⊆ nodes

-- A subgame rooted at a node
structure Subgame (G : ExtensiveFormGame) where
  subroot : ℕ
  subroot_mem : subroot ∈ G.nodes
  subnodes : Set ℕ
  subnodes_sub : subnodes ⊆ G.nodes
  subroot_in : subroot ∈ subnodes

-- Strategy profile (abstract)
structure StrategyProfile (G : ExtensiveFormGame) where
  action : ℕ → ℕ

-- Restriction of a strategy profile to a subgame
def restrict (G : ExtensiveFormGame) (σ : StrategyProfile G) (S : Subgame G) :
    StrategyProfile G :=
  σ  -- restriction is the same function, just considered on the subdomain

-- Nash equilibrium predicate (abstract)