import Mathlib

/-- A date-event tree for a multiperiod model.
    Nodes are (date, event) pairs forming a tree where each non-root node
    has a unique predecessor and each non-terminal node has successors. -/
structure DateEventTree where
  /-- The type of dates (time periods) -/
  Date : Type
  /-- The type of events -/
  Event : Type
  /-- The set of nodes, each a date-event pair -/
  nodes : Set (Date × Event)
  /-- The filtration: events observable at each date -/
  filtration : Date → Set Event
  /-- Membership constraint: each node (t, E) satisfies E ∈ F_t -/
  mem_filtration : ∀ p ∈ nodes, p.2 ∈ filtration p.1
  /-- The predecessor relation on nodes -/
  predecessor : Date × Event → Date × Event
  /-- The root node -/
  root : Date × Event
  /-- The root is a node -/
  root_mem : root ∈ nodes
  /-- Terminal nodes (leaves of the tree) -/
  terminal : Set (Date × Event)
  /-- Terminal nodes are nodes -/
  terminal_sub : terminal ⊆ nodes
  /-- Every non-root node has its predecessor in the tree -/
  pred_mem : ∀ p ∈ nodes, p ≠ root → predecessor p ∈ nodes
  /-- Every non-root node has a unique predecessor (the function `predecessor` encodes this) -/
  pred_unique : ∀ p ∈ nodes, p ≠ root → predecessor p ≠ p
  /-- Every non-terminal node has at least one successor -/
  exists_successor : ∀ p ∈ nodes, p ∉ terminal →
    ∃ q ∈ nodes, predecessor q = p