import Mathlib

/-- A policy in the insurance screening game. -/
structure InsurancePolicy where
  premium : ℝ
  coverage : ℝ

/-- An equilibrium candidate in the insurance screening game. -/
inductive EquilibriumType
  | pooling : InsurancePolicy → EquilibriumType
  | separating : InsurancePolicy → InsurancePolicy → EquilibriumType

/-- The insurance screening game (MWG Chapter 13 / Section 8).
    Axiomatizes Theorems 8.4 and 8.5 as properties of the game. -/
structure InsuranceScreeningGame where
  /-- The fair-odds policy for low-risk type -/
  ψ_bar_l : InsurancePolicy
  /-- The competitive (full-insurance fair-odds) policy for high-risk type -/
  ψ_c_h : InsurancePolicy
  /-- Predicate: this equilibrium type is a pure strategy SPE -/
  isPSSPE : EquilibriumType → Prop
  /-- Theorem 8.4: no pooling equilibrium is a PSSPE -/
  no_pooling : ∀ ψ, ¬ isPSSPE (EquilibriumType.pooling ψ)
  /-- Theorem 8.5: if a separating equilibrium is a PSSPE,
      the policies are uniquely determined -/
  separating_unique : ∀ ψ_l ψ_h,
    isPSSPE (EquilibriumType.separating ψ_l ψ_h) →
    ψ_l = ψ_bar_l ∧ ψ_h = ψ_c_h

/-- If a pure strategy subgame perfect equilibrium exists in the insurance
    screening game, it must be separating with ψ*_l = ψ̄_l and ψ*_h = ψ^c_h. -/
theorem Claim_8_uniqueness_if_exists (G : InsuranceScreeningGame)
    (e : EquilibriumType) (he : G.isPSSPE e) :
    ∃ ψ_l ψ_h, e = EquilibriumType.separating ψ_l ψ_h ∧
      ψ_l = G.ψ_bar_l ∧ ψ_h = G.ψ_c_h := by
  cases e with
  | pooling ψ =>
    exact absurd he (G.no_pooling ψ)
  | separating ψ_l ψ_h =>
    exact ⟨ψ_l, ψ_h, rfl, G.separating_unique ψ_l ψ_h he⟩