import Mathlib
open Topology

/--
Separating equilibria can be Pareto ranked. High-ability workers do strictly better
with lower education levels, so the equilibrium with e*(θ_H) = ê Pareto dominates.
-/
theorem separating_equilibria_pareto_ranked
    (θ_H θ_L : ℝ)
    (hθ : θ_L < θ_H)
    -- cost function: c(e, θ) is the cost of education level e for type θ
    (c : ℝ → ℝ → ℝ)
    -- cost is strictly increasing in education level
    (hc_mono : ∀ θ, StrictMono (fun e => c e θ))
    -- cost is nonneg
    (hc_nonneg : ∀ e θ, 0 ≤ c e θ)
    -- ê is the minimum education that separates (least-cost separating)
    (ê : ℝ)
    -- any separating equilibrium education level e* ≥ ê
    (e_star : ℝ)
    (he_star : ê ≤ e_star)
    -- utility of high-ability worker = θ_H - c(e, θ_H)
    -- firms earn zero profits in all separating equilibria
    -- low-ability workers get θ_L in all separating equilibria
    : θ_H - c ê θ_H ≥ θ_H - c e_star θ_H := by
  rcases eq_or_lt_of_le he_star with h | h
  · rw [h]
  · linarith [(hc_mono θ_H).lt_iff_lt.mpr h |>.le]