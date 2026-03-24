import Mathlib

/-- A von Neumann-Morgenstern (vNM) expected utility function.
    Maps lotteries (probability distributions over outcomes) to real-valued utilities. -/
structure VNMUtility (L : Type*) where
  /-- The utility function U(·) defined on lotteries. -/
  U : L → ℝ

/-- A Bernoulli utility function.
    Maps sure amounts of money to real-valued utilities. -/
structure BernoulliUtility where
  /-- The utility function u(·) defined on sure monetary amounts. -/
  u : ℝ → ℝ