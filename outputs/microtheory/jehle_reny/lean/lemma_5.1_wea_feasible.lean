import Mathlib

open BigOperators Finset
open Topology

noncomputable section

-- Def_5.1_feasible_allocations
def FeasibleAllocations {I : Type*} [Fintype I] {L : ℕ} (e : I → Fin L → ℝ) : Set (I → Fin L → ℝ) :=
  { x | (∀ i k, 0 ≤ x i k) ∧ (∑ i, x i) = (∑ i, e i) }

-- Def_5.4_excess_demand
noncomputable def aggregateExcessDemand {I : Type*} [Fintype I] {L : ℕ}
    (xd : I → (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (e : I → Fin L → ℝ)
    (p : Fin L → ℝ) : (Fin L → ℝ) :=
  (∑ i, xd i p (∑ k, p k * e i k)) - (∑ i, e i)

-- Def_5.5_walrasian_equilibrium