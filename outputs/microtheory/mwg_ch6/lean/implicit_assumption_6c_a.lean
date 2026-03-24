import Mathlib

open Topology

/-- A Bernoulli utility function is an increasing, continuous function ℝ → ℝ. -/
structure BernoulliUtility where
  /-- The utility function. -/
  u : ℝ → ℝ
  /-- u is strictly monotone (increasing). -/
  increasing : StrictMono u
  /-- u is continuous. -/
  continuous : Continuous u