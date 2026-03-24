import Mathlib

/-- A Bayesian game with a common prior. -/
structure BayesianGame where
  Player : Type
  Action : Player → Type
  TypeSpace : Player → Type
  prior : (∀ p, TypeSpace p) → ℝ
  utility : (∀ p, Action p) → (∀ p, TypeSpace p) → Player → ℝ

/-- An extensive form game where Nature moves first, reveals types privately,
    then players simultaneously choose actions. -/
structure NatureMoveFirstGame where
  Player : Type
  Action : Player → Type
  TypeSpace : Player → Type
  naturePrior : (∀ p, TypeSpace p) → ℝ
  utility : (∀ p, Action p) → (∀ p, TypeSpace p) → Player → ℝ

/-- A strategy: map from own type to action. -/
def BayesianGame.Strategy (G : BayesianGame) (p : G.Player) : Type :=
  G.TypeSpace p → G.Action p