import Mathlib
open Topology

/-- A separating equilibrium model for the insurance/labor market. -/
structure SeparatingEquilibrium where
  w_L : ℝ  -- wage for low-ability workers
  w_H : ℝ  -- wage for high-ability workers
  θ_L : ℝ  -- productivity of low-ability workers
  θ_H : ℝ  -- productivity of high-ability workers
  θ_L_pos : 0 < θ_L
  θ_H_pos : 0 < θ_H
  /-- Lemma 13.D.1: no firm can earn positive profits deviating, so each
      contract must pay at least the worker's productivity. -/
  no_underpay_L : w_L ≥ θ_L
  no_underpay_H : w_H ≥ θ_H
  /-- Firms break even overall (Lemma 13.D.1 aggregate condition):
      total wages cannot exceed total productivity in equilibrium. -/
  break_even : w_L + w_H ≤ θ_L + θ_H

theorem Lemma_13D3 (G : SeparatingEquilibrium) :
    G.w_L = G.θ_L ∧ G.w_H = G.θ_H := by
  constructor <;> linarith [G.no_underpay_L, G.no_underpay_H, G.break_even]