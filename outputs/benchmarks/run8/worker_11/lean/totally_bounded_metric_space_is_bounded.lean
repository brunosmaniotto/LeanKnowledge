import Mathlib

open Set

theorem totally_bounded_is_bounded [MetricSpace α] (h : TotallyBounded (univ : Set α)) :
    Bornology.IsBounded (univ : Set α) :=
  h.isBounded