import Mathlib

-- Axiomatize extensive form game concepts
axiom ExtensiveFormGame : Type
axiom StrategyProfile : ExtensiveFormGame → Type
axiom IsNashEquilibrium : ∀ (G : ExtensiveFormGame), StrategyProfile G → Prop
axiom IsSubgamePerfectNE : ∀ (G : ExtensiveFormGame), StrategyProfile G → Prop
axiom IsSequentiallyRational : ∀ (G : ExtensiveFormGame), StrategyProfile G → Prop

-- The game from Figure 7.27
axiom game_7_27 : ExtensiveFormGame
axiom strategy_L_m : StrategyProfile game_7_27

-- Key facts about (L, m) in game 7.27
axiom L_m_is_SPNE : IsSubgamePerfectNE game_7_27 strategy_L_m
axiom L_m_not_seq_rational : ¬ IsSequentiallyRational game_7_27 strategy_L_m

-- Every SPNE is a Nash equilibrium
axiom SPNE_is_NE : ∀ (G : ExtensiveFormGame) (σ : StrategyProfile G),
  IsSubgamePerfectNE G σ → IsNashEquilibrium G σ

theorem not_all_SPNE_sequentially_rational_and_not_all_NE_sequentially_rational :
    (∃ (G : ExtensiveFormGame) (σ : StrategyProfile G),
      IsSubgamePerfectNE G σ ∧ ¬ IsSequentiallyRational G σ) ∧
    (∃ (G : ExtensiveFormGame) (σ : StrategyProfile G),
      IsNashEquilibrium G σ ∧ ¬ IsSequentiallyRational G σ) := by
  constructor
  · exact ⟨game_7_27, strategy_L_m, L_m_is_SPNE, L_m_not_seq_rational⟩
  · exact ⟨game_7_27, strategy_L_m, SPNE_is_NE _ _ L_m_is_SPNE, L_m_not_seq_rational⟩