import Mathlib
open Topology

/-- A metric is a measure of distance. A metric space is a set together with
a notion of distance defined among the points within the set.
This is exactly Mathlib's `MetricSpace`. -/
abbrev MWG.IsMetricSpace (α : Type*) := MetricSpace α