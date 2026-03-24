import Mathlib

open Set
open Topology

/-- Two-Sector Model production set. Given a production function G(k, l, k'),
    the production set is Y = {((-k, 0, -l), (k', x, 0)) : k ≥ 0, l ≥ 0, k' ≥ 0, x ≤ G(k, l, k')} − ℝ⁶₊. -/
noncomputable def TwoSectorModel.productionSet (G : ℝ → ℝ → ℝ → ℝ) : Set (Fin 6 → ℝ) :=
  { y : Fin 6 → ℝ | ∃ k l k' x : ℝ,
    0 ≤ k ∧ 0 ≤ l ∧ 0 ≤ k' ∧ x ≤ G k l k' ∧
    ∃ d : Fin 6 → ℝ, (∀ i, 0 ≤ d i) ∧
      y 0 = -k - d 0 ∧
      y 1 = 0 - d 1 ∧
      y 2 = -l - d 2 ∧
      y 3 = k' - d 3 ∧
      y 4 = x - d 4 ∧
      y 5 = 0 - d 5 }

/-- Ramsey-Solow model as a special case where G(k, l, k') = F(k, l) - k'. -/
noncomputable def RamseySolowProductionSet (F : ℝ → ℝ → ℝ) : Set (Fin 6 → ℝ) :=
  TwoSectorModel.productionSet (fun k l k' => F k l - k')

/-- Cost-of-adjustment model as a special case where G(k, l, k') = F(k, l) - k' - γ(k' - k). -/
noncomputable def CostOfAdjustmentProductionSet (F : ℝ → ℝ → ℝ) (γ : ℝ → ℝ) : Set (Fin 6 → ℝ) :=
  TwoSectorModel.productionSet (fun k l k' => F k l - k' - γ (k' - k))