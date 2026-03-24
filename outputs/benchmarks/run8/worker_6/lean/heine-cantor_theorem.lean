import Mathlib

theorem heine_cantor [MetricSpace A1] [MetricSpace A2] [CompactSpace A1] (f : A1 → A2)
    (hf : Continuous f) : UniformContinuous f :=
  uniformContinuousOn_univ.mp (isCompact_univ.uniformContinuousOn_of_continuous hf.continuousOn)