import Mathlib

open Topology

/-- An assessment in an extensive form game is a pair (beliefs, behavioural strategy).
    The beliefs μ assign probabilities to nodes within each information set,
    and the behavioural strategy b specifies a mixed action at each information set.
    This is the central object for sequential equilibrium (MWG Definition 9.C.4). -/
structure Assessment (InfoSet : Type*) (Node : Type*) (Action : Type*) where
  /-- System of beliefs: for each information set, a probability distribution over
      nodes in that set. Represented as a function from nodes to probabilities in [0,1]. -/
  beliefs : Node → ℝ
  /-- Behavioural strategy: for each information set, a probability distribution over
      available actions. Represented as a function from info set and action to probability. -/
  strategy : InfoSet → Action → ℝ
  /-- Beliefs are non-negative -/
  beliefs_nonneg : ∀ x, 0 ≤ beliefs x
  /-- Beliefs are at most 1 -/
  beliefs_le_one : ∀ x, beliefs x ≤ 1
  /-- Strategy probabilities are non-negative -/
  strategy_nonneg : ∀ h a, 0 ≤ strategy h a
  /-- Strategy probabilities are at most 1 -/
  strategy_le_one : ∀ h a, strategy h a ≤ 1