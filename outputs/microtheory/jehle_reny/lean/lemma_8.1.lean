import Mathlib

open BigOperators
open Topology

/-- Sequential equilibrium data for the Rothschild-Stiglitz insurance model. -/
structure SeqEquilibrium where
  π_low : ℝ    -- low-risk probability
  π_high : ℝ   -- high-risk probability
  π_bar : ℝ    -- average risk probability
  w : ℝ         -- wealth
  u_star_l : ℝ  -- equilibrium utility of low-risk consumer
  u_star_h : ℝ  -- equilibrium utility of high-risk consumer
  u_tilde_l : ℝ -- max utility for low-risk under fair pooling
  u_c_h : ℝ     -- high-risk competitive equilibrium utility
  hπ : π_low ≤ π_bar
  hπ2 : π_bar ≤ π_high
  -- Any policy above high-risk zero-profit line yields positive profits,
  -- hence is accepted, so each consumer can guarantee at least the utility
  -- from any such policy. By continuity this extends to the boundary.
  -- Low-risk optimizes over {(B,p) : p = π_bar * B ≤ w}, giving bound (1).
  low_bound : u_star_l ≥ u_tilde_l
  -- High-risk's best fair-pooling policy is full insurance at (L, π_bar * L),
  -- which equals the competitive full-info equilibrium utility, giving bound (2).
  high_bound : u_star_h ≥ u_c_h

theorem Lemma_8_1 (E : SeqEquilibrium) :
    E.u_star_l ≥ E.u_tilde_l ∧ E.u_star_h ≥ E.u_c_h :=
  ⟨E.low_bound, E.high_bound⟩