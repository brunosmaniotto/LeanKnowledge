import Mathlib
open Topology
open BigOperators

/-- A type allocation for an economy with H consumer types and L goods.
    Each type h gets consumption bundle x_h ∈ ℝ^L, and feasibility requires
    that total consumption equals endowments plus some feasible production. -/
structure TypeAllocation (L H : ℕ) (Y : Set (Fin L → ℝ)) (ω : Fin H → Fin L → ℝ) where
  /-- Consumption bundle for each consumer type -/
  x : Fin H → Fin L → ℝ
  /-- The production plan witnessing feasibility -/
  y : Fin L → ℝ
  /-- The production plan is in the production set -/
  y_mem : y ∈ Y
  /-- Feasibility: total consumption equals endowment plus production -/
  feasible : ∀ l : Fin L, ∑ h : Fin H, x h l = y l + ∑ h : Fin H, ω h l