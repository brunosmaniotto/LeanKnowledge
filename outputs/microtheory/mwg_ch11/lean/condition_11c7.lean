import Mathlib

open scoped BigOperators
open Finset Filter Topology
open Filter
open Topology
open BigOperators

noncomputable section

theorem Condition_11C7
    (I : Type) [Fintype I]
    (p : I → ℝ) (c : ℝ → ℝ) (q_star : ℝ)
    (hq_nn : 0 ≤ q_star)
    (hc_diff : DifferentiableAt ℝ c q_star)
    (h_max : ∀ q : ℝ, 0 ≤ q →
      (∑ i : I, p i) * q - c q ≤ (∑ i : I, p i) * q_star - c q_star) :
    (∑ i : I, p i) ≤ deriv c q_star ∧
    (q_star > 0 → (∑ i : I, p i) = deriv c q_star) := by
  set S := ∑ i : I, p i
  set π : ℝ → ℝ := fun q => S * q - c q with hπ_def
  have hπd : HasDerivAt π (S - deriv c q_star) q_star := by
    have h1 : HasDerivAt (fun q => S * q) S q_star :=
      (hasDerivAt_id q_star).const_mul S |>.congr_deriv (by ring)
    have h2 : HasDerivAt c (deriv c q_star) q_star := hc_diff.hasDerivAt
    exact h1.sub h2
  have h_eq : q_star > 0 → S = deriv c q_star := by
    intro hq_pos
    have : IsLocalMax π q_star :=
      Filter.Eventually.mono (Ioi_mem_nhds hq_pos) fun y hy => h_max y (le_of_lt hy)
    linarith [this.hasDerivAt_eq_zero hπd]
  refine ⟨?_, h_eq⟩
  by_cases hpos : q_star > 0
  · linarith [h_eq hpos]
  · push_neg at hpos
    have hq0 : q_star = 0 := le_antisymm hpos hq_nn
    subst hq0
    suffices h : S - deriv c 0 ≤ 0 by linarith
    have hr : Tendsto (slope π 0) (𝓝[>] 0) (𝓝 (S - deriv c 0)) :=
      (hasDerivAt_iff_tendsto_slope.mp hπd).mono_left
        (nhdsWithin_mono 0 fun x (hx : 0 < x) => ne_of_gt hx)
    exact le_of_tendsto hr (eventually_of_mem self_mem_nhdsWithin fun t (ht : 0 < t) => by
      unfold slope
      rw [sub_zero]
      apply mul_nonpos_of_nonneg_of_nonpos
      · exact inv_nonneg.mpr ht.le
      · exact sub_nonpos.mpr (h_max t ht.le))