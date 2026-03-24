import Mathlib

open Topology

variable (α : Type _) [MetricSpace α]

theorem empty_is_open_in_metric_space : IsOpen (∅ : Set α) :=
  isOpen_empty