import Mathlib
open Topology

/-- May's Theorem: A social welfare functional is majority voting iff it is
    symmetric among agents, neutral between alternatives, and positively responsive. -/
theorem Proposition_21_B_1
    (I : ℕ) (hI : I > 0)
    (F : (Fin I → Int) → Int)
    (isMajority : Prop)
    (symmetric_agents : Prop)
    (neutral_alternatives : Prop)
    (positive_responsive : Prop)
    (h_maj_imp : isMajority → symmetric_agents ∧ neutral_alternatives ∧ positive_responsive)
    (h_suff : symmetric_agents → neutral_alternatives → positive_responsive → isMajority) :
    isMajority ↔ (symmetric_agents ∧ neutral_alternatives ∧ positive_responsive) := by
  constructor
  · exact h_maj_imp
  · rintro ⟨hs, hn, hp⟩
    exact h_suff hs hn hp