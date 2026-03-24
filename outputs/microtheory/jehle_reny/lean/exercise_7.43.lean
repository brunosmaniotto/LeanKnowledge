import Mathlib
open Topology

variable {Game Assessment Subgame : Type}

variable (IsConsistent : Assessment → Prop)
variable (SatisfiesBayesRule : Assessment → Prop)
variable (InducedAssessment : Assessment → Subgame → Assessment)
variable (SubgamesOf : Game → Set Subgame)

axiom consistent_implies_bayes :
  ∀ (σμ : Assessment), IsConsistent σμ → SatisfiesBayesRule σμ

axiom consistent_implies_bayes_in_subgame :
  ∀ (σμ : Assessment) (S : Subgame),
    IsConsistent σμ → SatisfiesBayesRule (InducedAssessment σμ S)

theorem exercise_7_43
    (Γ : Game) (σμ : Assessment) (h : IsConsistent σμ) :
    SatisfiesBayesRule σμ ∧
    ∀ S ∈ SubgamesOf Γ, SatisfiesBayesRule (InducedAssessment σμ S) := by
  exact ⟨consistent_implies_bayes IsConsistent SatisfiesBayesRule σμ h,
         fun S _ => consistent_implies_bayes_in_subgame IsConsistent SatisfiesBayesRule InducedAssessment σμ S h⟩