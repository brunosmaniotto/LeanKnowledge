import Mathlib
open Topology

/-- An economy in the Bradford (1978) tax incidence model.
    N towns each have a single price-taking firm with production function `f`.
    M units of labor are inelastically supplied. Output price is normalized to 1. -/
structure BradfordEconomy where
  /-- Number of towns -/
  N : ℕ
  /-- Positive number of towns -/
  hN : 0 < N
  /-- Total units of labor inelastically supplied -/
  M : ℝ
  /-- Positive labor endowment -/
  hM : 0 < M
  /-- Common production function for each town's firm -/
  f : ℝ → ℝ
  /-- Production function is strictly concave -/
  f_strictConcave : StrictConcaveOn ℝ (Set.Ici 0) f