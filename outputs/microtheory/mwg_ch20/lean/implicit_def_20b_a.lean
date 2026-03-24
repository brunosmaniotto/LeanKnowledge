import Mathlib
open Topology

/-- The recursive utility model (Koopmans 1960). Overall utility of a consumption
stream is defined recursively as V(c) = G(u(c₀), V(c')), where u is a current
utility function, G is an aggregator combining current and future utility, and
V(c') is the future utility of the continuation stream. -/
structure RecursiveUtilityModel (C : Type*) where
  /-- Current period utility function -/
  u : C → ℝ
  /-- Aggregator combining current utility and future utility into overall utility -/
  G : ℝ → ℝ → ℝ
  /-- The value function on consumption streams -/
  V : (ℕ → C) → ℝ
  /-- Recursive relation: V(c) = G(u(c₀), V(shift c)) -/
  recursive : ∀ (c : ℕ → C), V c = G (u (c 0)) (V (fun n => c (n + 1)))