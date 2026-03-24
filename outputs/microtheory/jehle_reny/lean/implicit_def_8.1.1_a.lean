import Mathlib

/-- A situation of asymmetric information: different agents possess
    different information. We model this as a collection of agents,
    a type of possible information states, and an assignment of
    information to each agent, such that at least two agents have
    distinct information. -/
structure AsymmetricInformation (Agent : Type*) (Info : Type*) where
  /-- Assignment of information to each agent. -/
  info : Agent → Info
  /-- There exist two agents with different information. -/
  asymmetric : ∃ a b : Agent, info a ≠ info b