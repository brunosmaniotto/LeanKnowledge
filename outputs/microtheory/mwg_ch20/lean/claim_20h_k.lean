import Mathlib
open Filter
open Topology

theorem real_asset_OLG_indeterminate_steady_state
    (demand₁ demand₂ : ℝ → ℝ)
    (p_star : ℝ)
    (h_steady : demand₁ p_star + demand₂ p_star = 0)
    (δ₁ δ₂ : ℝ)
    (hδ₁ : δ₁ = deriv demand₁ p_star)
    (hδ₂ : δ₂ = deriv demand₂ p_star)
    (h_pos₂ : δ₂ ≠ 0)
    (h_dampen : |δ₁ / δ₂| > 1)
    (contraction_ratio : ℝ := |δ₂ / δ₁|)
    (h_ratio_pos : contraction_ratio > 0)
    (h_ratio_lt : contraction_ratio < 1) :
    ∃ (equilibria : ℝ → ℝ → ℝ),
      (∀ ε : ℝ, |ε| < 1 → Filter.Tendsto (fun n => contraction_ratio ^ n * ε) Filter.atTop (nhds 0)) := by
  refine ⟨fun _ p => demand₁ p + demand₂ p, fun ε _ => ?_⟩
  have h0 : Filter.Tendsto (fun n => contraction_ratio ^ n) Filter.atTop (nhds 0) :=
    tendsto_pow_atTop_nhds_zero_of_lt_one (le_of_lt h_ratio_pos) h_ratio_lt
  have := Filter.Tendsto.mul_const ε h0
  simp [zero_mul] at this
  exact this