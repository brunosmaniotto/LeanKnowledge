import Mathlib

/-- A finite extensive form game. -/
axiom FiniteExtensiveFormGame : Type

/-- An assessment (strategy profile + belief system) for a finite extensive form game. -/
axiom Assessment : FiniteExtensiveFormGame → Type

/-- An assessment is consistent if the beliefs are obtained as limits of
    Bayes' rule applied to sequences of totally mixed strategies converging
    to the strategy profile (Kreps & Wilson 1982). -/
axiom IsConsistent : {Γ : FiniteExtensiveFormGame} → Assessment Γ → Prop

/-- An assessment is sequentially rational if, at every information set,
    the strategy maximizes expected payoff given the beliefs. -/
axiom IsSequentiallyRational : {Γ : FiniteExtensiveFormGame} → Assessment Γ → Prop

/-- Definition 7.22 (Kreps & Wilson 1982): An assessment for a finite extensive
    form game is a **sequential equilibrium** if it is both consistent and
    sequentially rational. -/
def IsSequentialEquilibrium {Γ : FiniteExtensiveFormGame} (a : Assessment Γ) : Prop :=
  IsConsistent a ∧ IsSequentiallyRational a