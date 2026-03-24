import Mathlib
open Set Filter
open scoped Topology

theorem limit_of_function_in_interval {a b ξ : ℝ} (f : ℝ → ℝ) (hξ : ξ ∈ Ioo a b)
    (h : ∀ x ∈ Ioo a b, (ξ ≤ f x ∧ f x ≤ x) ∨ (x ≤ f x ∧ f x ≤ ξ)) :
    Tendsto f (𝓝[Ioo a b] ξ) (𝓝 ξ) := by
  -- First prove the key inequality: |f x - ξ| ≤ |x - ξ| for x ∈ Ioo a b
  have h_abs : ∀ x ∈ Ioo a b, |f x - ξ| ≤ |x - ξ| := by
    intro x hx
    rcases h x hx with (⟨h1, h2⟩ | ⟨h3, h4⟩)
    · have hx' : ξ ≤ x := le_trans h1 h2
      have h_nonneg : 0 ≤ f x - ξ := by linarith
      have h_sub : f x - ξ ≤ x - ξ := by linarith
      rw [abs_of_nonneg h_nonneg, abs_of_nonneg (sub_nonneg.mpr hx')]
      linarith
    · have hx' : x ≤ ξ := le_trans h3 h4
      have h_nonpos : f x - ξ ≤ 0 := by linarith
      have h_sub : x - ξ ≤ f x - ξ := by linarith
      rw [abs_of_nonpos h_nonpos, abs_of_nonpos (sub_nonpos.mpr hx')]
      linarith
  -- The function x ↦ |x - ξ| is continuous at ξ
  have h_cont_at : ContinuousAt (fun x => |x - ξ|) ξ :=
    continuous_abs.continuousAt.comp (continuous_id.continuousAt.sub continuous_const.continuousAt)
  -- Therefore, |x - ξ| tends to 0 as x → ξ
  have h_cont_tendsto : Tendsto (fun x => |x - ξ|) (𝓝 ξ) (𝓝 0) := by
    simpa [sub_self] using h_cont_at.tendsto
  -- Restrict this limit to Ioo a b
  have h_cont' : Tendsto (fun x => |x - ξ|) (𝓝[Ioo a b] ξ) (𝓝 0) :=
    tendsto_nhdsWithin_of_tendsto_nhds h_cont_tendsto
  -- The inequality holds eventually in Ioo a b
  have h_bound : ∀ᶠ x in 𝓝[Ioo a b] ξ, |f x - ξ| ≤ |x - ξ| := by
    filter_upwards [self_mem_nhdsWithin] with x hx
    exact h_abs x hx
  -- The absolute value is nonnegative
  have h_nonneg : ∀ᶠ x in 𝓝[Ioo a b] ξ, 0 ≤ |f x - ξ| := by
    filter_upwards [self_mem_nhdsWithin] with x hx
    exact abs_nonneg _
  -- Apply the squeeze theorem to get |f x - ξ| → 0
  have h_squeeze : Tendsto (fun x => |f x - ξ|) (𝓝[Ioo a b] ξ) (𝓝 0) :=
    squeeze_zero' h_nonneg h_bound h_cont'
  -- Convert absolute value limit to metric limit in ℝ
  rw [tendsto_iff_dist_tendsto_zero]
  simp_rw [Real.dist_eq]
  exact h_squeeze