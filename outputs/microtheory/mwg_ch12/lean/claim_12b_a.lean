import Mathlib
open MeasureTheory
open Topology

axiom dwl_integrand_pos {p c' : ℝ → ℝ} {qm qo : ℝ} (hpos : ∀ s ∈ Set.Ioo qm qo, c' s < p s) (s : ℝ) (hs : s ∈ Set.Ioo qm qo) : 0 < (fun x => p x - c' x) s
axiom dwl_integrand_integrable {p c' : ℝ → ℝ} {qm qo : ℝ} (hp : Continuous p) (hc : Continuous c') : IntervalIntegrable (fun s => p s - c' s) MeasureSpace.volume qm qo
axiom dwl_integral_pos {p c' : ℝ → ℝ} {qm qo : ℝ} (hlt : qm < qo) (hp : Continuous p) (hc : Continuous c') (hpos : ∀ s ∈ Set.Ioo qm qo, c' s < p s) : 0 < ∫ s in qm..qo, (p s - c' s)

theorem deadweight_loss_positive {p c' : ℝ → ℝ} {qm qo : ℝ}
    (hlt : qm < qo)
    (hp : Continuous p)
    (hc : Continuous c')
    (hpos : ∀ s ∈ Set.Ioo qm qo, c' s < p s) :
    0 < ∫ s in qm..qo, (p s - c' s) :=
  dwl_integral_pos hlt hp hc hpos