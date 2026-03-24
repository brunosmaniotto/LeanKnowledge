import Mathlib
open Topology
open BigOperators

/-- A Bayesian game with finitely many players, finite type spaces, and finite action spaces. -/
structure BayesianGame (nPlayers : ℕ) where
  Θ : Fin nPlayers → Type                -- type space for each player
  A : Fin nPlayers → Type                -- action space for each player
  [instΘFin : ∀ i, Fintype (Θ i)]
  [instΘDec : ∀ i, DecidableEq (Θ i)]
  [instAFin : ∀ i, Fintype (A i)]
  p : (∀ i, Θ i) → ℝ                    -- joint prior over type profiles
  u : Fin nPlayers → (∀ i, A i) → (∀ i, Θ i) → ℝ  -- payoff function

attribute [instance] BayesianGame.instΘFin BayesianGame.instΘDec BayesianGame.instAFin

variable {nPlayers : ℕ} (G : BayesianGame nPlayers)

/-- A pure strategy (decision rule) for player i: maps each realization of
    player i's type to an action. -/
def BayesianGame.PureStrategy (G : BayesianGame nPlayers) (i : Fin nPlayers) : Type :=
  G.Θ i → G.A i

/-- Player i's expected payoff given a profile of pure strategies. -/
noncomputable def BayesianGame.expectedPayoff
    (G : BayesianGame nPlayers)
    (s : ∀ i, G.PureStrategy i)
    (i : Fin nPlayers) : ℝ :=
  ∑ θ : (∀ j, G.Θ j), G.p θ * G.u i (fun j => s j (θ j)) θ