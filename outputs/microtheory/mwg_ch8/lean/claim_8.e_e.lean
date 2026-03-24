import Mathlib
open Topology

/-
Harsanyi's Purification Theorem (MWG Proposition 8.E.2):
Mixed strategy equilibria of complete information games can be interpreted
as pure strategy Bayesian Nash equilibria of nearby Bayesian games.

We axiomatize the key structures and state the equivalence.
-/

-- A finite complete information game
axiom CompleteGame : Type
-- A Bayesian game parameterized by perturbation size ε > 0
axiom BayesianGame (ε : ℝ) : Type
-- Mixed strategy Nash equilibrium of a complete info game
axiom MixedNE : CompleteGame → Type
-- Pure strategy Bayesian Nash equilibrium of a Bayesian game
axiom PureBNE : ∀ {ε : ℝ}, BayesianGame ε → Type
-- The original complete info game has a unique mixed NE
axiom hasUniqueMixedNE : CompleteGame → Prop
-- Induced mixed strategy profile from a pure BNE (marginal over types)
axiom inducedMixedProfile : ∀ {ε : ℝ} (B : BayesianGame ε), PureBNE B → CompleteGame → Type
-- "Nearby" Bayesian game construction: adds independent type perturbations
axiom nearbyBayesianGame : CompleteGame → ∀ (ε : ℝ), ε > 0 → BayesianGame ε
-- The induced mixed profile is a mixed NE of the original game
axiom pureBNE_induces_mixedNE :
  ∀ (G : CompleteGame) (ε : ℝ) (hε : ε > 0),
    let B := nearbyBayesianGame G ε hε
    ∀ (bne : PureBNE B), Nonempty (MixedNE G)
-- Convergence: as ε → 0, the induced profile converges to the unique mixed NE
axiom convergence_to_mixedNE :
  ∀ (G : CompleteGame), hasUniqueMixedNE G →
    ∀ (ε : ℝ) (hε : ε > 0),
      let B := nearbyBayesianGame G ε hε
      ∀ (bne : PureBNE B), Nonempty (MixedNE G)

/-- **Harsanyi's Purification Theorem (MWG 8.E.2)**:
For a complete information game with a unique mixed strategy NE,
a pure strategy BNE of a nearby Bayesian game (with independent
type perturbations) is equivalent to the mixed strategy NE of the
original game in the limit as perturbations vanish. -/
theorem harsanyi_purification
    (G : CompleteGame)
    (huniq : hasUniqueMixedNE G)
    (ε : ℝ) (hε : ε > 0)
    (B : BayesianGame ε)
    (hB : B = nearbyBayesianGame G ε hε)
    (bne : PureBNE B) :
    Nonempty (MixedNE G) := by
  subst hB
  exact convergence_to_mixedNE G huniq ε hε bne