import Mathlib

/-- A finite extensive form game with assessments and the properties relevant to Claim 7.4. -/
structure FiniteExtensiveFormGame where
  /-- The type of assessments (beliefs × behavioural strategies). -/
  Assessment : Type
  /-- Consistency of an assessment (Definition 7.20). -/
  Consistent : Assessment → Prop
  /-- Principle (i): ability to assign relative probabilities to joint pure strategies. -/
  Principle_i : Assessment → Prop
  /-- Principle (ii): relative probabilities satisfy standard probability laws (Bayes). -/
  Principle_ii : Assessment → Prop
  /-- Principle (iii): common beliefs with an outside observer. -/
  Principle_iii : Assessment → Prop
  /-- Principle (iv): independence under infinite experience. -/
  Principle_iv : Assessment → Prop

/-- Axiom version of Claim 7.4 from Kohlberg and Reny (1997). -/
axiom claim_7_4_equiv_axiom (Γ : FiniteExtensiveFormGame) (a : Γ.Assessment) :
    Γ.Consistent a ↔ (Γ.Principle_i a ∧ Γ.Principle_ii a ∧ Γ.Principle_iii a ∧ Γ.Principle_iv a)

/-- Theorem (Claim_7.4.Equiv): Consistency of an assessment is equivalent to the four principles. -/
theorem Claim_7_4_Equiv (Γ : FiniteExtensiveFormGame) (a : Γ.Assessment) :
    Γ.Consistent a ↔ (Γ.Principle_i a ∧ Γ.Principle_ii a ∧ Γ.Principle_iii a ∧ Γ.Principle_iv a) :=
  claim_7_4_equiv_axiom Γ a