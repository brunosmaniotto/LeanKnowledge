import Mathlib

open Set
open Topology

/-- Symmetric information insurance market equilibrium.
    Under symmetric information, each consumer's accident probability is observable
    by insurance companies. Policy i pays `L` dollars to consumer i upon accident.
    Since accidents for distinct consumers correspond to distinct states, policies
    for distinct consumers are distinct commodities and may command distinct
    Walrasian equilibrium prices p*_i. -/
structure SymmetricInfoInsuranceEquilibrium (I : Type*) [Fintype I] where
  /-- Common loss amount covered by each policy -/
  L : ℝ
  L_pos : 0 < L
  /-- Observable accident probability for each consumer -/
  accidentProb : I → ℝ
  prob_range : ∀ i, accidentProb i ∈ Ioo 0 1
  /-- Walrasian equilibrium price p*_i for consumer i's insurance policy -/
  eqPrice : I → ℝ
  price_nonneg : ∀ i, 0 ≤ eqPrice i