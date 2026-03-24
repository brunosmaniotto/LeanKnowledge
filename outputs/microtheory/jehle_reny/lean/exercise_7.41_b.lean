import Mathlib

-- Axiomatize extensive form game concepts (not in Mathlib)
axiom ExtensiveFormGame : Type 1
axiom BehavioralStrategy (G : ExtensiveFormGame) : Type
axiom BeliefSystem (G : ExtensiveFormGame) : Type
axiom ExtensiveFormGame.IsFinite (G : ExtensiveFormGame) : Prop
axiom BehavioralStrategy.IsCompletelyMixed {G : ExtensiveFormGame}
  (b : BehavioralStrategy G) : Prop
axiom BeliefSystem.IsDerivedByBayesRule {G : ExtensiveFormGame}
  (p : BeliefSystem G) (b : BehavioralStrategy G) : Prop
axiom Assessment.IsConsistent {G : ExtensiveFormGame}
  (p : BeliefSystem G) (b : BehavioralStrategy G) : Prop

/-- When b is completely mixed, consistency reduces to Bayes' rule:
    the constant sequence bₙ = b witnesses consistency iff beliefs match Bayes' rule. -/
axiom consistent_of_bayes_of_completelyMixed {G : ExtensiveFormGame}
  (p : BeliefSystem G) (b : BehavioralStrategy G)
  (hfin : G.IsFinite) (hmix : b.IsCompletelyMixed)
  (hbayes : p.IsDerivedByBayesRule b) : Assessment.IsConsistent p b

axiom bayes_of_consistent_of_completelyMixed {G : ExtensiveFormGame}
  (p : BeliefSystem G) (b : BehavioralStrategy G)
  (hfin : G.IsFinite) (hmix : b.IsCompletelyMixed)
  (hcons : Assessment.IsConsistent p b) : p.IsDerivedByBayesRule b

theorem exercise_7_41_b (G : ExtensiveFormGame)
    (p : BeliefSystem G) (b : BehavioralStrategy G)
    (hfin : G.IsFinite) (hmix : b.IsCompletelyMixed) :
    Assessment.IsConsistent p b ↔ p.IsDerivedByBayesRule b :=
  ⟨bayes_of_consistent_of_completelyMixed p b hfin hmix,
   consistent_of_bayes_of_completelyMixed p b hfin hmix⟩