import Mathlib
open Topology

abbrev ProductionPlan (n : ℕ) := Fin n → ℝ

def ProductionPlan.isInput {n : ℕ} (y : ProductionPlan n) (k : Fin n) : Prop := y k < 0