import Mathlib
open Topology

noncomputable section

theorem ramsey_solow_steady_state_properties
    (f : ℝ → ℝ)
    (nδ : ℝ)
    (hf_diff : Differentiable ℝ f)
    (hf'_diff : Differentiable ℝ (deriv f))
    (hf'_pos : ∀ k, 0 < k → deriv f k > 0)
    (hf'_strict_anti : StrictAntiOn (deriv f) (Set.Ioi 0))
    (hf''_neg : ∀ k, 0 < k → deriv (deriv f) k < 0)
    (hnδ_pos : nδ > 0)
    (h_golden : ∃ k_bar > 0, deriv f k_bar = nδ) :
    (StrictAntiOn (deriv f) (Set.Ioi 0)) ∧
    (∀ a b : ℝ, 0 < a → a < b → f a - a * deriv f a < f b - b * deriv f b) := by
  constructor
  · exact hf'_strict_anti
  · intro a b ha hab
    have hb_pos : 0 < b := by linarith
    have w_deriv_pos : ∀ x, 0 < x → 0 < -(x * deriv (deriv f) x) := by
      intro x hx
      have := hf''_neg x hx
      nlinarith
    set w := fun k => f k - k * deriv f k with hw_def
    have hw_hasderiv : ∀ x, HasDerivAt w (-(x * deriv (deriv f) x)) x := by
      intro x
      have h1 : HasDerivAt f (deriv f x) x :=
        (hf_diff x).hasDerivAt
      have h2 : HasDerivAt (deriv f) (deriv (deriv f) x) x :=
        (hf'_diff x).hasDerivAt
      have h3 : HasDerivAt id 1 x := hasDerivAt_id x
      have h4 : HasDerivAt (fun k => k * deriv f k) (1 * deriv f x + x * deriv (deriv f) x) x :=
        h3.mul h2
      have h5 : HasDerivAt w (deriv f x - (1 * deriv f x + x * deriv (deriv f) x)) x :=
        h1.sub h4
      convert h5 using 1
      ring
    have hab_pos : 0 < b - a := by linarith
    have hw_cont : ContinuousOn w (Set.Icc a b) := by
      apply ContinuousOn.sub (hf_diff.continuous.continuousOn)
      exact ContinuousOn.mul continuousOn_id (hf'_diff.continuous.continuousOn)
    have hw_diff : ∀ x ∈ Set.Ioo a b, HasDerivAt w (-(x * deriv (deriv f) x)) x :=
      fun x _ => hw_hasderiv x
    obtain ⟨c, hc_mem, hc_eq⟩ := exists_hasDerivAt_eq_slope w
      (fun x => -(x * deriv (deriv f) x)) hab hw_cont hw_diff
    have hc_pos : 0 < c := by
      have := hc_mem.1; linarith
    have hderiv_pos := w_deriv_pos c hc_pos
    -- hc_eq : -(c * deriv (deriv f) c) = (w b - w a) / (b - a)
    have hquot_pos : (w b - w a) / (b - a) > 0 := by linarith
    have : w b - w a > 0 := by
      exact (div_pos_iff_of_pos_right hab_pos).mp hquot_pos
    linarith

end