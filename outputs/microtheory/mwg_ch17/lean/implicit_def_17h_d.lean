import Mathlib
open Topology

/-- A Lyapunov function for a dynamic system given by a flow `φ : ℝ → X → X`.
    It is a continuous real-valued function that is strictly decreasing along
    non-stationary trajectories and equals zero exactly at stationary points. -/
structure LyapunovFunction (X : Type*) [TopologicalSpace X] (φ : ℝ → X → X) where
  /-- The underlying real-valued function. -/
  toFun : X → ℝ
  /-- Continuity of the Lyapunov function. -/
  continuous_toFun : Continuous toFun
  /-- The function is non-increasing along trajectories: for all x and 0 ≤ s ≤ t,
      V(φ(t, x)) ≤ V(φ(s, x)). -/
  decreasing_along_trajectory : ∀ (x : X) (s t : ℝ), 0 ≤ s → s ≤ t →
    toFun (φ t x) ≤ toFun (φ s x)
  /-- The function equals zero exactly at stationary points (fixed points of the flow). -/
  zero_iff_stationary : ∀ (x : X), toFun x = 0 ↔ ∀ (t : ℝ), φ t x = x