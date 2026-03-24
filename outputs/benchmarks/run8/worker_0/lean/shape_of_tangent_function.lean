import Mathlib

open Real
open Set
open Filter

theorem tan_continuous_on_open_interval : ContinuousOn tan (Set.Ioo (-(π / 2)) (π / 2)) := by
  refine continuousOn_tan.mono fun x hx => ?_
  exact (cos_pos_of_mem_Ioo hx).ne.symm