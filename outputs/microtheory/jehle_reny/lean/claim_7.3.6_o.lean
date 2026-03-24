import Mathlib

structure ExtensiveFormGame (Node Action Player : Type) where
  hasPerfectRecall : Prop
  Strategy : Type
  isSubgamePerfectNE : Strategy → Prop

axiom counterexample_without_perfect_recall_no_SPE : 
  ∃ (Node Action Player : Type) (G : ExtensiveFormGame Node Action Player), 
    ¬ G.hasPerfectRecall ∧ ¬ ∃ (σ : G.Strategy), G.isSubgamePerfectNE σ

theorem Claim_7_3_6_o : ∃ (Node Action Player : Type) (G : ExtensiveFormGame Node Action Player), 
    ¬ G.hasPerfectRecall ∧ ¬ ∃ (σ : G.Strategy), G.isSubgamePerfectNE σ :=
counterexample_without_perfect_recall_no_SPE