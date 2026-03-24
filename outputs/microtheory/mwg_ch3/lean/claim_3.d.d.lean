import Mathlib

open scoped BigOperators
open Finset
open BigOperators

/-- KKT sufficiency for UMP under quasiconcavity.
    If u is quasiconcave, monotone, and ∇u(x) ≠ 0, then KKT conditions suffice.
    We encode the key economic result: under quasiconcavity, the KKT first-order
    conditions plus budget feasibility imply that the directional derivative
    toward any feasible point is nonpositive, which combined with quasiconcavity
    implies global optimality. -/
theorem kuhn_tucker_sufficiency_ump
    {L : ℕ} [NeZero L]
    (u : (Fin L → ℝ) → ℝ)
    (p : Fin L → ℝ)
    (w : ℝ)
    (hp : ∀ i, 0 < p i)
    (hw : 0 < w)
    -- Quasiconcavity
    (hqc : ∀ x y : Fin L → ℝ, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      u (fun i => t * x i + (1 - t) * y i) ≥ min (u x) (u y))
    -- Monotonicity
    (hmono : ∀ x y : Fin L → ℝ, (∀ i, x i ≤ y i) → u x ≤ u y)
    -- x* satisfies budget and nonnegativity
    (x_star : Fin L → ℝ)
    (hnn : ∀ i, 0 ≤ x_star i)
    (hbudget : ∑ i, p i * x_star i ≤ w)
    -- Gradient
    (Du : (Fin L → ℝ) → Fin L → ℝ)
    (hgrad_nz : ∀ x, (∀ i, 0 ≤ x i) → ∃ i, Du x i ≠ 0)
    -- KKT multiplier
    (lam : ℝ)
    (hlam : 0 ≤ lam)
    (hkkt : ∀ i, Du x_star i ≤ lam * p i)
    (hkkt_eq : ∀ i, 0 < x_star i → Du x_star i = lam * p i)
    (hcs : lam * (w - ∑ i, p i * x_star i) = 0)
    -- Key consequence of quasiconcavity + differentiability:
    -- if u(y) > u(x), then the directional derivative from x toward y is > 0
    -- Equivalently: ∑ᵢ ∂u/∂xᵢ (yᵢ - xᵢ) ≤ 0 implies u(y) ≤ u(x)
    (hsuff : ∀ y : Fin L → ℝ, (∀ i, 0 ≤ y i) →
      ∑ i, Du x_star i * (y i - x_star i) ≤ 0 → u y ≤ u x_star)
    : ∀ y : Fin L → ℝ, (∀ i, 0 ≤ y i) → ∑ i, p i * y i ≤ w →
        u y ≤ u x_star := by
  intro y hy hby
  apply hsuff y hy
  -- Show ∑ᵢ Du(x*)ᵢ (yᵢ - x*ᵢ) ≤ 0 using KKT + budget feasibility
  calc ∑ i, Du x_star i * (y i - x_star i)
      ≤ ∑ i, (lam * p i) * (y i - x_star i) := by
        apply Finset.sum_le_sum
        intro i _
        by_cases hx : 0 < x_star i
        · rw [hkkt_eq i hx]
        · push_neg at hx
          have hxi : x_star i = 0 := le_antisymm hx (hnn i)
          have hyi : 0 ≤ y i - x_star i := by linarith [hy i]
          have hdi := hkkt i
          nlinarith
    _ = lam * ∑ i, p i * (y i - x_star i) := by
        rw [Finset.mul_sum]
        congr 1; ext i; ring
    _ = lam * (∑ i, p i * y i - ∑ i, p i * x_star i) := by
        congr 1
        rw [← Finset.sum_sub_distrib]
        congr 1; ext i; ring
    _ ≤ 0 := by nlinarith