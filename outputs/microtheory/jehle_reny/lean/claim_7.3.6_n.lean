import Mathlib
open Topology
set_option linter.unusedVariables false

theorem Claim_7_3_6_n {BehaviouralStrategyProfile MixedStrategyProfile : Type}
    (EquivBehaviouralMixed : BehaviouralStrategyProfile → MixedStrategyProfile → Prop)
    (Claim_7_3_6_j : ∀ (σ : BehaviouralStrategyProfile), ∃ (m : MixedStrategyProfile), EquivBehaviouralMixed σ m)
    (IsSubgamePerfectBehavioural : BehaviouralStrategyProfile → Prop)
    (IsSubgamePerfectMixed : MixedStrategyProfile → Prop)
    (IsNashBehavioural : BehaviouralStrategyProfile → Prop)
    (IsNashMixed : MixedStrategyProfile → Prop)
    (behavioural_subgame_perfect_iff_mixed_subgame_perfect :
      ∀ (σ : BehaviouralStrategyProfile) (m : MixedStrategyProfile),
        EquivBehaviouralMixed σ m → (IsSubgamePerfectBehavioural σ ↔ IsSubgamePerfectMixed m))
    (behavioural_nash_iff_mixed_nash :
      ∀ (σ : BehaviouralStrategyProfile) (m : MixedStrategyProfile),
        EquivBehaviouralMixed σ m → (IsNashBehavioural σ ↔ IsNashMixed m))
    (Claim_9B_SPNE_Is_NE : ∀ (m : MixedStrategyProfile), IsSubgamePerfectMixed m → IsNashMixed m)
    (σ : BehaviouralStrategyProfile)
    (h : IsSubgamePerfectBehavioural σ) : IsNashBehavioural σ := by
  obtain ⟨m, hm⟩ := Claim_7_3_6_j σ
  have h_subgame := (behavioural_subgame_perfect_iff_mixed_subgame_perfect σ m hm).mp h
  have h_nash := Claim_9B_SPNE_Is_NE m h_subgame
  exact (behavioural_nash_iff_mixed_nash σ m hm).mpr h_nash