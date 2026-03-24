import Mathlib

open Topology

theorem poincare_conjecture_3d (M : Type*) [TopologicalSpace M] [CompactSpace M] [T2Space M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 3)) M]
    [HasGroupoid M (contDiffGroupoid 0 (modelWithCornersSelf ℝ (EuclideanSpace ℝ (Fin 3))))]
    (hconn : ConnectedSpace M) (hsimply : SimplyConnectedSpace M) :
    Nonempty (M ≃ₜ Metric.sphere (0 : EuclideanSpace ℝ (Fin 4)) 1) := by
  sorry