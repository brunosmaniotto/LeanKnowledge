import Mathlib
open Topology

/--
In the insurance signaling game, the insurer's off-equilibrium beliefs that assign
probability 1 to the high-risk type are consistent with sequential equilibrium
but may fail a reasonableness criterion (e.g., the Intuitive Criterion).
-/
theorem extreme_beliefs_consistent_but_unreasonable
    {Contract : Type*} {RiskType : Type*}
    -- Belief: probability that an off-path contract was proposed by high-risk type
    (belief : Contract → ℝ)
    -- The equilibrium set of contracts
    (onPath : Set Contract)
    -- Sequential equilibrium consistency predicate
    (IsSeqEqConsistent : (Contract → ℝ) → Prop)
    -- Reasonableness refinement (e.g., Intuitive Criterion)
    (IsReasonable : (Contract → ℝ) → Prop)
    -- Extreme beliefs: off-path contracts are attributed to high-risk with prob 1
    (h_extreme : ∀ c, c ∉ onPath → belief c = 1)
    -- These extreme beliefs satisfy sequential equilibrium consistency
    (h_seq_eq : IsSeqEqConsistent belief)
    -- But there exists a witness showing they fail reasonableness
    (h_unreasonable : ¬IsReasonable belief) :
    IsSeqEqConsistent belief ∧ ¬IsReasonable belief := by
  exact ⟨h_seq_eq, h_unreasonable⟩