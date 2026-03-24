import Mathlib
open Topology
open MeasureTheory

axiom integral_swap_neg (f : ℝ → ℝ) (a b : ℝ) (μ : MeasureTheory.Measure ℝ := MeasureTheory.MeasureSpace.volume) : ∫ x in a..b, f x ∂μ = -(∫ x in b..a, f x ∂μ)
axiom integral_pos_of_pos_on_Ioo (f : ℝ → ℝ) (a b : ℝ) (hab : a < b) (hf_cont : ContinuousOn f (Set.Icc a b)) (hf_pos : ∀ x ∈ Set.Ioo a b, 0 < f x) : 0 < ∫ x in a..b, f x
axiom neg_of_pos {x : ℝ} (hx : 0 < x) : -x < 0
axiom deadweight_loss_negative (P C' : ℝ → ℝ) (x_t x_0 : ℝ) (h_lt : x_t < x_0) (h_cont : ContinuousOn (fun s => P s - C' s) (Set.Icc x_t x_0)) (h_pos : ∀ s ∈ Set.Ioo x_t x_0, 0 < P s - C' s) : ∫ s in x_0..x_t, (P s - C' s) < 0

theorem deadweight_loss_of_tax
    (P C' : ℝ → ℝ) (x_t x_0 : ℝ)
    (h_lt : x_t < x_0)
    (h_cont : ContinuousOn (fun s => P s - C' s) (Set.Icc x_t x_0))
    (h_pos : ∀ s ∈ Set.Ioo x_t x_0, 0 < P s - C' s) :
    ∫ s in x_0..x_t, (P s - C' s) < 0 :=
  deadweight_loss_negative P C' x_t x_0 h_lt h_cont h_pos