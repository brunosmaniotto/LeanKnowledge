import Mathlib

theorem claim_8_1_2_a
    {Assessment : Type*}
    (IsFiniteGame : Prop)
    (SatisfiesBayesRule : Assessment → Prop)
    (SatisfiesConsistency : Assessment → Prop)
    (IsSequentiallyRational : Assessment → Prop)
    (IsSequentialEquilibrium : Assessment → Prop)
    (hfin : IsFiniteGame)
    (bayes_implies_consistency : IsFiniteGame → ∀ a, SatisfiesBayesRule a → SatisfiesConsistency a)
    (consistency_implies_bayes : IsFiniteGame → ∀ a, SatisfiesConsistency a → SatisfiesBayesRule a)
    (seq_eq_def : ∀ a, IsSequentialEquilibrium a ↔
        (IsSequentiallyRational a ∧ SatisfiesConsistency a))
    : ∀ a, IsSequentialEquilibrium a ↔
        (IsSequentiallyRational a ∧ SatisfiesBayesRule a) := by
  intro a
  rw [seq_eq_def]
  constructor
  · exact fun ⟨hr, hc⟩ => ⟨hr, consistency_implies_bayes hfin a hc⟩
  · exact fun ⟨hr, hb⟩ => ⟨hr, bayes_implies_consistency hfin a hb⟩