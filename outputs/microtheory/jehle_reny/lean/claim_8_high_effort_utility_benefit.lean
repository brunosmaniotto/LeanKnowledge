import Mathlib

open BigOperators Finset
open Topology

/-- When l − B_l is strictly increasing (the deductible condition), there is a strictly
positive utility benefit to exerting high effort, and the optimal policy sets this
benefit exactly equal to the disutility cost d(1) − d(0). -/
theorem claim_8_high_effort_utility_benefit
    (L : ℕ)
    (π : Fin (L + 1) → Fin 2 → ℝ)
    (u : ℝ → ℝ)
    (d : Fin 2 → ℝ)
    (w p : ℝ)
    (B : Fin (L + 1) → ℝ)
    -- u is strictly increasing
    (hu_strict_mono : StrictMono u)
    -- Deductible condition: l - B_l is strictly increasing in l
    (h_deductible : ∀ i j : Fin (L + 1), i < j → (↑i : ℝ) - B i < (↑j : ℝ) - B j)
    -- MLRP covariance property (Exercise 8.13): for any strictly decreasing function f,
    -- Σ_l (π_l(1) - π_l(0)) f(l) > 0
    (h_mlrp_cov : ∀ f : Fin (L + 1) → ℝ,
      (∀ i j : Fin (L + 1), i < j → f j < f i) →
      ∑ l : Fin (L + 1), (π l 1 - π l 0) * f l > 0)
    -- Binding IC constraint: utility benefit = disutility cost
    (h_ic_binding :
      ∑ l : Fin (L + 1), (π l 1 - π l 0) * u (w - p - ↑l + B l) = d 1 - d 0)
    -- Disutility of high effort exceeds that of low effort
    (h_d_pos : d 1 - d 0 > 0)
    : (∑ l : Fin (L + 1), (π l 1 - π l 0) * u (w - p - ↑l + B l) > 0) ∧
      (∑ l : Fin (L + 1), (π l 1 - π l 0) * u (w - p - ↑l + B l) = d 1 - d 0) := by
  constructor
  · -- u(w - p - l + B_l) is strictly decreasing in l because:
    -- h_deductible gives l - B_l strictly increasing, so w - p - l + B_l is strictly decreasing,
    -- and hu_strict_mono preserves the strict ordering through u.
    apply h_mlrp_cov
    intro i j hij
    apply hu_strict_mono
    have h := h_deductible i j hij
    linarith
  · exact h_ic_binding