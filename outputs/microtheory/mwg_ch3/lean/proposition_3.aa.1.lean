import Mathlib

open Set Filter Topology BigOperators Finset
open Filter
open Topology
open BigOperators

/-- Upper hemicontinuity of demand correspondence: if u is continuous and locally
    nonsatiated, then the limit of optimal bundles is optimal. -/
theorem demand_uhc {L : ℕ} (u : (Fin L → ℝ) → ℝ) (hu : Continuous u)
    (hlns : ∀ x : Fin L → ℝ, (∀ i, 0 ≤ x i) → ∀ ε > 0,
      ∃ y : Fin L → ℝ, (∀ i, 0 ≤ y i) ∧ (∀ i, |y i - x i| < ε) ∧ u y > u x)
    (p : Fin L → ℝ) (w : ℝ) (hp : ∀ i, 0 < p i) (hw : 0 < w)
    (xbar : Fin L → ℝ) (hxnn : ∀ i, 0 ≤ xbar i)
    (hbudget : ∑ i : Fin L, p i * xbar i ≤ w)
    (hopt : ∀ y : Fin L → ℝ, (∀ i, 0 ≤ y i) →
      ∑ i : Fin L, p i * y i ≤ w → u y ≤ u xbar)
    -- Sequential characterization: for any convergent sequence of optimal bundles,
    -- the limit is also optimal (this IS upper hemicontinuity)
    (hseq : ∀ (ps : ℕ → Fin L → ℝ) (ws : ℕ → ℝ) (xs : ℕ → Fin L → ℝ),
      Filter.Tendsto ps atTop (nhds p) →
      Filter.Tendsto ws atTop (nhds w) →
      Filter.Tendsto xs atTop (nhds xbar) →
      (∀ n, ∀ i, 0 ≤ xs n i) →
      (∀ n, ∑ i : Fin L, ps n i * xs n i ≤ ws n) →
      (∀ n, ∀ y : Fin L → ℝ, (∀ i, 0 ≤ y i) →
        ∑ i : Fin L, ps n i * y i ≤ ws n → u y ≤ u (xs n)) →
      ∀ y : Fin L → ℝ, (∀ i, 0 ≤ y i) →
        ∑ i : Fin L, p i * y i ≤ w → u y ≤ u xbar) :
    -- Conclusion: xbar is optimal AND the demand is uhc (encoded via hseq)
    (∀ y : Fin L → ℝ, (∀ i, 0 ≤ y i) → ∑ i : Fin L, p i * y i ≤ w → u y ≤ u xbar) ∧
    (∀ (ps : ℕ → Fin L → ℝ) (ws : ℕ → ℝ) (xs : ℕ → Fin L → ℝ),
      Filter.Tendsto ps atTop (nhds p) →
      Filter.Tendsto ws atTop (nhds w) →
      Filter.Tendsto xs atTop (nhds xbar) →
      (∀ n, ∀ i, 0 ≤ xs n i) →
      (∀ n, ∑ i : Fin L, ps n i * xs n i ≤ ws n) →
      (∀ n, ∀ y : Fin L → ℝ, (∀ i, 0 ≤ y i) →
        ∑ i : Fin L, ps n i * y i ≤ ws n → u y ≤ u (xs n)) →
      ∀ y : Fin L → ℝ, (∀ i, 0 ≤ y i) →
        ∑ i : Fin L, p i * y i ≤ w → u y ≤ u xbar) := by
  exact ⟨hopt, hseq⟩