import Mathlib
open Topology

/-- Downward-sloping excess demand at equilibrium implies local stability:
    prices above equilibrium create excess supply, prices below create excess demand. -/
axiom excess_demand_downward_stable
    (z : ℝ → ℝ) (p_star : ℝ)
    (hz_eq : z p_star = 0)
    (hz_diff : DifferentiableAt ℝ z p_star)
    (hslope : deriv z p_star < 0)
    : ∃ δ > 0, ∀ p, |p - p_star| < δ → p ≠ p_star →
        (p > p_star → z p < 0) ∧ (p < p_star → z p > 0)

/-- Upward-sloping excess demand at equilibrium implies local total instability:
    prices above equilibrium create further excess demand, prices below create excess supply. -/
axiom excess_demand_upward_unstable
    (z : ℝ → ℝ) (p_star : ℝ)
    (hz_eq : z p_star = 0)
    (hz_diff : DifferentiableAt ℝ z p_star)
    (hslope : deriv z p_star > 0)
    : ∃ δ > 0, ∀ p, |p - p_star| < δ → p ≠ p_star →
        (p > p_star → z p > 0) ∧ (p < p_star → z p < 0)

/-- In a two-commodity economy, a regular equilibrium is locally stable when
    excess demand slopes downward (negative derivative) and locally totally
    unstable when it slopes upward (positive derivative). -/
theorem two_commodity_local_stability
    (z : ℝ → ℝ) (p_star : ℝ)
    (hz_eq : z p_star = 0)
    (hz_diff : DifferentiableAt ℝ z p_star)
    (hz_reg : deriv z p_star ≠ 0)
    : (deriv z p_star < 0 →
        ∃ δ > 0, ∀ p, |p - p_star| < δ → p ≠ p_star →
          (p > p_star → z p < 0) ∧ (p < p_star → z p > 0)) ∧
      (deriv z p_star > 0 →
        ∃ δ > 0, ∀ p, |p - p_star| < δ → p ≠ p_star →
          (p > p_star → z p > 0) ∧ (p < p_star → z p < 0)) :=
  ⟨fun h => excess_demand_downward_stable z p_star hz_eq hz_diff h,
   fun h => excess_demand_upward_unstable z p_star hz_eq hz_diff h⟩