import Mathlib

open Filter
open scoped Topology

theorem convergent_is_cauchy (x : ℕ → ℝ) (l : ℝ) (h : Tendsto x atTop (𝓝 l)) : CauchySeq x :=
  h.cauchySeq