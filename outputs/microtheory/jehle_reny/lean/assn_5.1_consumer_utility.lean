import Mathlib
open Topology

/-- Assumption 5.1: Consumer utility on ℝⁿ₊ is continuous, strongly increasing,
    and strictly quasiconcave. -/
structure Assn_5_1_ConsumerUtility {n : ℕ} (u : (Fin n → ℝ) → ℝ) : Prop where
  /-- (i) u is continuous on ℝⁿ₊ -/
  continuous_on : ContinuousOn u {x : Fin n → ℝ | ∀ i, 0 ≤ x i}
  /-- (ii) u is strongly increasing: x ≤ y componentwise with x ≠ y implies u(x) < u(y) -/
  strongly_increasing : ∀ x y : Fin n → ℝ, (∀ i, 0 ≤ x i) → (∀ i, 0 ≤ y i) →
    (∀ i, x i ≤ y i) → x ≠ y → u x < u y
  /-- (iii) u is strictly quasiconcave on ℝⁿ₊ -/
  strictly_quasiconcave : ∀ x y : Fin n → ℝ, (∀ i, 0 ≤ x i) → (∀ i, 0 ≤ y i) →
    x ≠ y → ∀ t : ℝ, 0 < t → t < 1 →
    u (fun i => t * x i + (1 - t) * y i) > min (u x) (u y)