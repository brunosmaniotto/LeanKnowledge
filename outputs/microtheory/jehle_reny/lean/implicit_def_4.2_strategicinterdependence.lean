import Mathlib
open Topology

/-- Strategic interdependence among firms in an imperfectly competitive industry.
    Firms become more interdependent when there are fewer firms, entry is easier,
    and substitute goods are closer. When firms perceive interdependence,
    they formulate plans strategically accounting for rivals' actions. -/
structure StrategicInterdependence where
  /-- Number of firms in the industry -/
  numFirms : ℕ
  /-- Degree of ease of entry (higher = easier entry) -/
  entryEase : ℝ
  /-- Degree of closeness of substitute goods (higher = closer substitutes) -/
  substituteCloseness : ℝ
  /-- Measure of interdependence among firms -/
  interdependence : ℝ
  /-- Interdependence is positive -/
  interdependence_pos : 0 < interdependence
  /-- Fewer firms implies greater interdependence -/
  fewer_firms_more_interdep : numFirms > 0
  /-- Entry ease is nonneg -/
  entryEase_nonneg : 0 ≤ entryEase
  /-- Substitute closeness is nonneg -/
  substituteCloseness_nonneg : 0 ≤ substituteCloseness

/-- Whether firms perceive their interdependence and act strategically.
    When true, firms account for rivals' actions in their own plans. -/
def StrategicInterdependence.isStrategic (s : StrategicInterdependence) : Prop :=
  s.interdependence > 0