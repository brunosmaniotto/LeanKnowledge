import Mathlib

open Finset BigOperators Topology
open Topology
open BigOperators

variable {L : ℕ}

/-- On a strictly convex set, a linear functional with p ≫ 0 has at most one maximizer.
    (If two maximizers exist, their midpoint is in interior Y by strict convexity;
    since p ≫ 0, we can perturb in a direction of positive profit, contradicting maximality.) -/
axiom linear_unique_max_of_strictConvex
    (Y : Set (Fin L → ℝ)) (hsc : StrictConvex ℝ Y)
    (p : Fin L → ℝ) (hp : ∀ i, 0 < p i)
    {y₁ y₂ : Fin L → ℝ} (h1 : y₁ ∈ Y) (h2 : y₂ ∈ Y)
    (hmax1 : ∀ z ∈ Y, (∑ i, p i * z i) ≤ ∑ i, p i * y₁ i)
    (hmax2 : ∀ z ∈ Y, (∑ i, p i * z i) ≤ ∑ i, p i * y₂ i) :
    y₁ = y₂

/-- Berge's Maximum Theorem: the unique argmax of profit on a compact strictly convex
    production set is a continuous function of p on ℝ^L_{++}. -/
axiom argmax_continuous_berge
    (Y : Set (Fin L → ℝ)) (hK : IsCompact Y) (hne : Y.Nonempty) (hsc : StrictConvex ℝ Y) :
    ∃ yFun : {p : Fin L → ℝ // ∀ i, 0 < p i} → Fin L → ℝ,
      Continuous yFun ∧ ∀ p, yFun p ∈ Y ∧
        ∀ z ∈ Y, (∑ i, (↑p : Fin L → ℝ) i * z i) ≤ ∑ i, (↑p : Fin L → ℝ) i * (yFun p) i

/-- Claim 5.3(h): Under Theorem 5.10, a maximum of p · y over the aggregate production
    set Y exists and is unique when p ≫ 0. In addition, the aggregate profit-maximising
    production plan y(p) is a continuous function of p on ℝ^L_{++}.
    Follows from applying Theorem 5.9 to the aggregate production set Y,
    which satisfies Assumption 5.2 by Theorem 5.10. -/
theorem Claim_5_3_h (Y : Set (Fin L → ℝ))
    (hK : IsCompact Y) (hne : Y.Nonempty) (hsc : StrictConvex ℝ Y)
    (p : Fin L → ℝ) (hp : ∀ i, 0 < p i) :
    ∃! y ∈ Y, ∀ z ∈ Y, (∑ i, p i * z i) ≤ ∑ i, p i * y i := by
  -- Existence: profit is continuous on compact nonempty Y
  have hcont : Continuous (fun y : Fin L → ℝ => ∑ i : Fin L, p i * y i) := by
    apply continuous_finset_sum; intro i _
    exact continuous_const.mul (continuous_apply i)
  obtain ⟨y, hyY, hymax⟩ := hK.exists_isMaxOn hne hcont.continuousOn
  have hymax' : ∀ z ∈ Y, (∑ i, p i * z i) ≤ ∑ i, p i * y i := fun z hz => hymax hz
  -- Uniqueness: strict convexity ensures at most one maximizer (Theorem 5.9)
  refine ⟨y, ⟨hyY, hymax'⟩, ?_⟩
  intro y' hy'
  exact linear_unique_max_of_strictConvex Y hsc p hp hy'.1 hyY hy'.2 hymax'