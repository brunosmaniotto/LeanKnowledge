import Mathlib
open Topology

structure HiddenInfoConstrainedOptimum where
  Allocation : Type
  principalProfit : Allocation → ℝ
  agentUtility : Allocation → ℝ
  isIC : Allocation → Prop
  isIR : Allocation → Prop
  firstBest : Allocation
  secondBest : Allocation
  sb_ic : isIC secondBest
  sb_ir : isIR secondBest
  /-- First-best Pareto dominates second-best (so SB is inefficient) -/
  fb_pareto_dominates : agentUtility firstBest ≥ agentUtility secondBest ∧
    principalProfit firstBest ≥ principalProfit secondBest ∧
    (agentUtility firstBest > agentUtility secondBest ∨
     principalProfit firstBest > principalProfit secondBest)
  /-- First-best is not incentive compatible -/
  fb_not_ic : ¬ isIC firstBest
  /-- Second-best maximizes principal profit among IC+IR allocations -/
  sb_optimal_profit : ∀ a, isIC a → isIR a →
    principalProfit a ≤ principalProfit secondBest
  /-- Second-best maximizes agent utility among IC+IR allocations
      that give principal at least as much profit -/
  sb_optimal_agent : ∀ a, isIC a → isIR a →
    principalProfit a ≥ principalProfit secondBest →
    agentUtility a ≤ agentUtility secondBest

theorem Claim_14C_h (M : HiddenInfoConstrainedOptimum) :
    (M.agentUtility M.firstBest ≥ M.agentUtility M.secondBest ∧
     M.principalProfit M.firstBest ≥ M.principalProfit M.secondBest ∧
     (M.agentUtility M.firstBest > M.agentUtility M.secondBest ∨
      M.principalProfit M.firstBest > M.principalProfit M.secondBest)) ∧
    (∀ a, M.isIC a → M.isIR a →
      ¬(M.agentUtility a ≥ M.agentUtility M.secondBest ∧
        M.principalProfit a ≥ M.principalProfit M.secondBest ∧
        (M.agentUtility a > M.agentUtility M.secondBest ∨
         M.principalProfit a > M.principalProfit M.secondBest))) := by
  refine ⟨M.fb_pareto_dominates, fun a hic hir ⟨ha_u, ha_p, ha_strict⟩ => ?_⟩
  have hp := M.sb_optimal_profit a hic hir
  have hu := M.sb_optimal_agent a hic hir (le_antisymm hp ha_p ▸ le_refl _)
  rcases ha_strict with h | h
  · linarith
  · linarith