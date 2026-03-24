import Mathlib

open Topology

/-- Consumer preferences in the moral hazard model (Definition 8).
    The consumer has a strictly increasing, strictly concave vNM utility function
    over wealth, initial wealth w > L (loss), and a disutility of effort function
    with d(1) > d(0). -/
structure ConsumerUtility where
  /-- vNM utility function over wealth levels -/
  u : ℝ → ℝ
  /-- Initial wealth -/
  w : ℝ
  /-- Loss amount -/
  L : ℝ
  /-- Disutility of effort as a function of effort level (0 or 1) -/
  d : ℝ → ℝ
  /-- u is strictly increasing -/
  u_strictMono : StrictMono u
  /-- u is strictly concave -/
  u_strictConcave : StrictConcaveOn ℝ Set.univ u
  /-- Initial wealth exceeds the loss -/
  w_gt_L : w > L
  /-- High effort is more costly than low effort -/
  d_high_gt_low : d 1 > d 0

/-- The consumer's vNM expected utility over wealth at a given effort level e. -/
noncomputable def ConsumerUtility.utilityAtEffort (c : ConsumerUtility) (e : ℝ) (wealth : ℝ) : ℝ :=
  c.u wealth - c.d e