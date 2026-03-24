import Mathlib

noncomputable def realUnitsEmbedding : ℝˣ →* ℂˣ :=
  Units.map (algebraMap ℝ ℂ).toMonoidHom

theorem realUnitsEmbedding.range_normal : realUnitsEmbedding.range.Normal :=
  Subgroup.normal_of_comm _