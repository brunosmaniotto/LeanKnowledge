import Mathlib
open Topology

structure CompEq where
  wage : ℝ

inductive WorkerStatus | indifferent | employed

def workerUtility (s : WorkerStatus) (e : CompEq) : ℝ :=
  match s with
  | .indifferent => 0
  | .employed => e.wage