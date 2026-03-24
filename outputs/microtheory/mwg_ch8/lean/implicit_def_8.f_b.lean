import Mathlib

open Finset BigOperators
open Filter
open Topology
open BigOperators

/-- A finite normal-form game with n players. -/
structure MixedGame where
  I : Type*
  S : I → Type*
  [instFintypeI : Fintype I]
  [instDecEqI : DecidableEq I]
  [instFintypeS : ∀ i, Fintype (S i)]
  [instDecEqS : ∀ i, DecidableEq (S i)]
  [instInhabS : ∀ i, Inhabited (S i)]
  utility : I → (∀ i, S i) → ℝ

attribute [instance] MixedGame.instFintypeI MixedGame.instDecEqI
attribute [instance] MixedGame.instFintypeS MixedGame.instDecEqS MixedGame.instInhabS

variable (G : MixedGame)

/-- A mixed strategy profile assigns each player a distribution over pure strategies. -/
def MixedGame.MixedProfile (G : MixedGame) := ∀ i, G.S i → ℝ

/-- Expected utility for player i under mixed profile σ. -/
noncomputable def MixedGame.expectedUtility (G : MixedGame) (i : G.I) (σ : G.MixedProfile) : ℝ :=
  ∑ s : (j : G.I) → G.S j, (∏ j, σ j (s j)) * G.utility i s

/-- A proper equilibrium (Myerson, 1978): a refinement of trembling-hand perfection
    where more costly mistakes occur with strictly lower probability.
    Formally, σ is a limit of ε-proper strategy profiles where, for each player i,
    if pure strategy s yields strictly lower expected payoff than s' against σ_ε,
    then σ_ε(s) ≤ ε · σ_ε(s'). -/
structure MixedGame.ProperEquilibrium (G : MixedGame) where
  profile : G.MixedProfile
  approx : ℕ → G.MixedProfile
  eps : ℕ → ℝ
  eps_pos : ∀ k, 0 < eps k
  eps_lim : Filter.Tendsto eps Filter.atTop (nhds 0)
  approx_lim : ∀ i s, Filter.Tendsto (fun k => approx k i s) Filter.atTop (nhds (profile i s))
  proper_condition : ∀ k i (s s' : G.S i),
    G.expectedUtility i (approx k) < G.expectedUtility i (Function.update (approx k) i (fun t => if t = s' then 1 else 0)) →
    approx k i s ≤ eps k * approx k i s'