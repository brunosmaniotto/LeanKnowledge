import Mathlib

open Filter Topology
open Topology

theorem tax_incidence_limits (x' : ℝ) (hx : x' < 0) :
    Tendsto (fun q' : ℝ => -x' / (x' - q')) atTop (nhds 0) ∧
    -x' / (x' - (0 : ℝ)) = -1 := by
  have hx_ne : x' ≠ 0 := ne_of_lt hx
  refine ⟨?_, by simp [sub_zero, neg_div, div_self hx_ne]⟩
  suffices h : Tendsto (fun q' : ℝ => x' / (q' - x')) atTop (nhds 0) by
    exact h.congr (fun q' => by rw [neg_div, ← div_neg, neg_sub])
  have hsub : Tendsto (fun q' : ℝ => q' - x') atTop atTop := by
    rw [tendsto_atTop_atTop]
    exact fun b => ⟨b + x', fun q' hq => by linarith⟩
  have hinv : Tendsto (fun q' : ℝ => (q' - x')⁻¹) atTop (nhds 0) :=
    tendsto_inv_atTop_zero.comp hsub
  simp_rw [div_eq_mul_inv]
  simpa [mul_zero] using tendsto_const_nhds.mul hinv