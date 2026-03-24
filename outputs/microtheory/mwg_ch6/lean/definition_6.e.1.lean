import Mathlib
open Topology

/-- A random variable over a finite state space with positive probabilities.
    Maps states to non-negative monetary outcomes (ℝ₊). -/
structure RandomVariable (S : Type*) [Fintype S] [DecidableEq S] where
  /-- Objective probability for each state -/
  prob : S → ℝ
  /-- Each state has strictly positive probability -/
  prob_pos : ∀ s, prob s > 0
  /-- The random variable: a function from states to non-negative reals -/
  g : S → ℝ
  /-- Outcomes are non-negative -/
  g_nonneg : ∀ s, g s ≥ 0