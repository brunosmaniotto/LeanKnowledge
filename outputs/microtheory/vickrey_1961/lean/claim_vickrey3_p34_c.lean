import Mathlib

open MeasureTheory ProbabilityTheory
open Topology
open ProbabilityTheory

/-- If value drawings are independent, interchanging one player's bid strategy
    (a measurable function of their value) leaves other players unaffected:
    the transformed variable remains independent of the others. -/
theorem claim_vickrey3_p34_c
    {Ω : Type*} {mΩ : MeasurableSpace Ω} {μ : Measure Ω}
    {α β γ : Type*} [MeasurableSpace α] [MeasurableSpace β] [MeasurableSpace γ]
    (v_i : Ω → α) (v_others : Ω → β)
    (bid : α → γ)
    (hind : IndepFun v_i v_others μ)
    (hm : Measurable bid) :
    IndepFun (bid ∘ v_i) v_others μ :=
  hind.comp hm measurable_id