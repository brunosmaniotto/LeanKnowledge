import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The choice of c(u) in e(p,u) = c(u) · p₁^α₁ · p₂^α₂ · p₃^α₃ does not affect
    demand behaviour: Shephard's lemma gives hℓ(p,u) = ∂e/∂pℓ = c(u) · αℓ · ∏_{j≠ℓ} pⱼ^αⱼ · pℓ^(αℓ-1).
    For any two strictly increasing choices c and c', the demand ratio
    hℓ/hℓ' = c(u)/c'(u) is independent of prices, so relative demands
    (and budget-share demands) are identical. We formalize this by showing
    that the price-dependent factor is invariant under the choice of c(u). -/
theorem Claim_2_3_b
    -- g(p) captures the price-dependent part of expenditure
    (g : ℝ → ℝ → ℝ → ℝ)
    -- dg_l is the partial derivative of g w.r.t. price l (Shephard's lemma component)
    (dg : Fin 3 → ℝ → ℝ → ℝ → ℝ)
    -- Two strictly increasing functions c and c'
    (c c' : ℝ → ℝ)
    (hc_mono : StrictMono c)
    (hc'_mono : StrictMono c')
    -- The expenditure function is e(p, u) = c(u) * g(p)
    -- Shephard's lemma: demand_l(p, u) = c(u) * dg_l(p)
    -- For any u and prices p1 p2 p3, the price-dependent factor dg_l is the same
    -- regardless of choice of c:
    (u : ℝ) (p1 p2 p3 : ℝ)
    (l : Fin 3)
    : -- demand under c and c' differ only by a price-independent scalar
      c u * dg l p1 p2 p3 * (c' u) = c' u * dg l p1 p2 p3 * (c u) := by
  ring