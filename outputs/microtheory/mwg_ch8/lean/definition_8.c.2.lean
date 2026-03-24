import Mathlib
open scoped symmDiff
open Topology

/-- A finite normal-form game with player set `I`, strategy sets `S i`,
    and utility functions `u i`. Mixed strategies live in `Δ(S i)`. -/
structure NormalFormGame (I : Type*) [Fintype I] (S : I → Type*) [∀ i, Fintype (S i)] where
  /-- Utility for player `i` given a profile of mixed strategies. -/
  u : (i : I) → ((j : I) → PMF (S j)) → ℝ

variable {I : Type*} [Fintype I] [DecidableEq I]
  {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)] [∀ i, Nonempty (S i)]

/-- The set of best responses for player `i` given opponents' mixed strategies.
    A mixed strategy `σ_i` is a best response if no other strategy yields higher utility. -/
noncomputable def bestResponses (G : NormalFormGame I S) (i : I)
    (σ_minus_i : (j : I) → PMF (S j)) : Set (PMF (S i)) :=
  {σ_i : PMF (S i) |
    ∀ τ_i : PMF (S i),
      G.u i (Function.update σ_minus_i i τ_i) ≤ G.u i (Function.update σ_minus_i i σ_i)}

/-- A strategy `σ_i` is never a best response relative to a set of feasible strategy profiles
    if there is no opponent mixed-strategy profile (drawn from the feasible sets) for which
    `σ_i` is a best response. -/
noncomputable def neverBestResponse (G : NormalFormGame I S) (i : I)
    (feasible : (j : I) → Set (PMF (S j))) (σ_i : PMF (S i)) : Prop :=
  ∀ σ_minus_i : (j : I) → PMF (S j),
    (∀ j, σ_minus_i j ∈ feasible j) →
    σ_i ∉ bestResponses G i σ_minus_i

/-- One round of iterated removal of never-best-response strategies:
    keep only those strategies that are a best response to some
    profile drawn from the current feasible sets. -/
noncomputable def eliminateNeverBR (G : NormalFormGame I S)
    (feasible : (j : I) → Set (PMF (S j))) : (j : I) → Set (PMF (S j)) :=
  fun i => {σ_i ∈ feasible i | ¬neverBestResponse G i feasible σ_i}

/-- The iterated elimination sequence: `R^0 = Set.univ`, `R^{n+1} = eliminate(R^n)`. -/
noncomputable def iteratedBR (G : NormalFormGame I S) : ℕ → (j : I) → Set (PMF (S j))
  | 0 => fun _ => Set.univ
  | n + 1 => eliminateNeverBR G (iteratedBR G n)

/-- **Rationalizable strategies** (Definition 8.C.2, MWG).
    The strategies in `Δ(S_i)` that survive the iterated removal of strategies
    that are never a best response. Equivalently, the intersection of all
    finite rounds of elimination. -/
noncomputable def rationalizableStrategies (G : NormalFormGame I S) (i : I) : Set (PMF (S i)) :=
  ⋂ n, iteratedBR G n i