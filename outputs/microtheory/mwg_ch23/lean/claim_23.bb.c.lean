import Mathlib

-- Model the example from MWG 23.BB.1
-- Two states, two agents, three outcomes, three-stage mechanism

inductive State23BB : Type where
  | θ₁ | θ₂
  deriving DecidableEq, Fintype

inductive Outcome23BB : Type where
  | x | y | z
  deriving DecidableEq, Fintype

-- The social choice function from Example 23.BB.1
def scf_23BB : State23BB → Outcome23BB
  | .θ₁ => .x
  | .θ₂ => .y

-- Stage 1 actions for Agent 1
inductive Stage1Action : Type where
  | L | C
  deriving DecidableEq, Fintype

-- Stage 2 actions for Agent 2
inductive Stage2Action : Type where
  | agree | challenge
  deriving DecidableEq, Fintype

-- Stage 3 actions for Agent 1
inductive Stage3Action : Type where
  | chooseY | chooseZ
  deriving DecidableEq, Fintype

-- Preference orderings: in state θ₁, agent 1 prefers x > y > z
-- In state θ₂, agent 1 prefers y > x > z (non-monotonic change)
-- The mechanism outcome given the action profile