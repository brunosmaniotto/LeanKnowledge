import Mathlib
open Topology

theorem Proposition_3_I_2
    {n : ℕ}
    (e : EuclideanSpace ℝ (Fin n) → ℝ)
    (p0 d : EuclideanSpace ℝ (Fin n))
    (w : ℝ)
    (he_val : e p0 = w)
    (he_diff : DifferentiableAt ℝ e p0)
    (h_pos : fderiv ℝ e p0 d > 0) :
    ∃ ᾱ : ℝ, 0 < ᾱ ∧ ᾱ ≤ 1 ∧ ∀ α : ℝ, 0 < α → α < ᾱ → e (p0 + α • d) > w := by
  set g : ℝ → ℝ := fun t => e (p0 + t • d) with hg_def
  have hg_deriv : HasDerivAt g (fderiv ℝ e p0 d) 0 := by
    have h1 : HasFDerivAt e (fderiv ℝ e p0) (p0 + (0 : ℝ) • d) := by
      simp only [zero_smul, add_zero]; exact he_diff.hasFDerivAt
    have h2 : HasDerivAt (fun t : ℝ => p0 + t • d) d 0 := by
      have := ((hasDerivAt_id (0 : ℝ)).smul_const d).const_add p0
      rwa [one_smul] at this
    exact h1.comp_hasDerivAt 0 h2
  have hg0 : g 0 = w := by
    change e (p0 + (0 : ℝ) • d) = w
    rw [zero_smul, add_zero]; exact he_val
  have hhalf : (0 : ℝ) < fderiv ℝ e p0 d / 2 := by linarith
  have hilo := hg_deriv.isLittleO
  rw [Asymptotics.isLittleO_iff] at hilo
  obtain ⟨s, hs_mem, hs_bound⟩ := Filter.eventually_iff_exists_mem.mp (hilo hhalf)
  obtain ⟨ε, hε_pos, hε_sub⟩ := Metric.mem_nhds_iff.mp hs_mem
  refine ⟨min ε 1, lt_min hε_pos one_pos, min_le_right _ _, fun α hα_pos hα_lt => ?_⟩
  have hα_lt_ε : α < ε := lt_of_lt_of_le hα_lt (min_le_left _ _)
  have hα_in_s : α ∈ s := hε_sub (Metric.mem_ball.mpr (by
    rw [dist_zero_right, Real.norm_eq_abs, abs_of_pos hα_pos]; exact hα_lt_ε))
  have h_bound := hs_bound α hα_in_s
  simp only [sub_zero, ContinuousLinearMap.toSpanSingleton_apply, smul_eq_mul,
             Real.norm_eq_abs, abs_of_pos hα_pos, hg0] at h_bound
  have h1 := (abs_le.mp h_bound).1
  have h2 : 0 < fderiv ℝ e p0 d / 2 * α := mul_pos hhalf hα_pos
  show g α > w
  nlinarith