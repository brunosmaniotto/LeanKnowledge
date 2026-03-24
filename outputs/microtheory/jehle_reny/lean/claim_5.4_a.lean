import Mathlib
open Finset BigOperators
open Topology
open BigOperators

/-- A Walrasian equilibrium for a contingent commodity economy with `I` consumers,
    `J` firms, and `NM` contingent commodities (N physical goods × M states). -/
structure ContingentWalrasianEquilibrium (I J : Type*) [Fintype I] [Fintype J] (NM : ℕ) where
  /-- Equilibrium consumption allocations -/
  x : I → Fin NM → ℝ
  /-- Equilibrium production plans -/
  y : J → Fin NM → ℝ
  /-- Initial endowments -/
  e : I → Fin NM → ℝ
  /-- Equilibrium price vector -/
  p : Fin NM → ℝ
  /-- Prices are strictly positive: p* ∈ ℝ^{NM}_{++} -/
  prices_positive : ∀ l, p l > 0
  /-- Market clearing: demand = supply + endowments for each contingent commodity -/
  market_clearing : ∀ l : Fin NM,
    ∑ i : I, x i l = ∑ j : J, y j l + ∑ i : I, e i l

/-- Under Theorem 5.13 hypotheses applied to the contingent commodity economy (n = NM goods),
    the Walrasian equilibrium satisfies market clearing:
    ∑_i x̂ⁱ_l = ∑_j ŷʲ_l + ∑_i eⁱ_l for every contingent commodity l ∈ {1,...,NM}. -/
theorem Claim_5_4_a {I J : Type*} [Fintype I] [Fintype J] {NM : ℕ}
    (eq : ContingentWalrasianEquilibrium I J NM) :
    ∀ l : Fin NM,
      ∑ i : I, eq.x i l = ∑ j : J, eq.y j l + ∑ i : I, eq.e i l :=
  eq.market_clearing