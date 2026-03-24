import Mathlib
open BigOperators

/-- A Bayesian game with finite players, finite strategy sets, and finite type spaces. -/
structure BayesianGame where
  I : Type*                          -- players
  S : I → Type*                      -- pure strategies per player
  Θ : I → Type*                      -- type spaces per player
  [instFI : Fintype I]
  [instDecEqI : DecidableEq I]
  [instFS : ∀ i, Fintype (S i)]
  [instFΘ : ∀ i, Fintype (Θ i)]
  prob : (∀ i, Θ i) → ℝ             -- joint prior over type profiles
  utility : I → (∀ i, S i) → (∀ i, Θ i) → ℝ  -- payoff given actions and types

attribute [instance] BayesianGame.instFI BayesianGame.instDecEqI
  BayesianGame.instFS BayesianGame.instFΘ

/-- A decision rule for player i maps their type to a pure strategy. -/
def DecisionRule (G : BayesianGame) (i : G.I) := G.Θ i → G.S i

/-- The expected payoff for player i under a profile of decision rules. -/
noncomputable def BayesianGame.expectedPayoff (G : BayesianGame)
    (i : G.I) (profile : ∀ j, DecisionRule G j) : ℝ :=
  ∑ θ : (∀ j, G.Θ j), G.prob θ * G.utility i (fun j => profile j (θ j)) θ

/-- A (pure strategy) Bayesian Nash equilibrium: a profile of decision rules such that
    no player can improve their expected payoff by unilaterally changing their decision rule. -/
structure BayesianNashEquilibrium (G : BayesianGame) where
  profile : ∀ i, DecisionRule G i
  is_equilibrium : ∀ (i : G.I) (si' : DecisionRule G i),
    G.expectedPayoff i profile ≥
    G.expectedPayoff i (Function.update profile i si')