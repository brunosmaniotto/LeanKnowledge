import Mathlib
open Topology

-- Basic game theory infrastructure
inductive Player : Type
  | one
  | two
deriving DecidableEq, Fintype

structure StrategyProfile (ActionSpace : Player → Type) where
  strategy : (p : Player) → ActionSpace p

structure GameOutcome where
  terminalNode : ℕ
  probability : ℝ

noncomputable def inducedOutcome {ActionSpace : Player → Type}
    (payoffFn : StrategyProfile ActionSpace → Player → ℝ)
    (s : StrategyProfile ActionSpace) : Player → ℝ :=
  payoffFn s

theorem Claim_7D_b {ActionSpace : Player → Type}
    (payoffFn : StrategyProfile ActionSpace → Player → ℝ)
    (s : StrategyProfile ActionSpace)
    (p : Player) :
    ∃ u : ℝ, inducedOutcome payoffFn s p = u := by
  exact ⟨inducedOutcome payoffFn s p, rfl⟩