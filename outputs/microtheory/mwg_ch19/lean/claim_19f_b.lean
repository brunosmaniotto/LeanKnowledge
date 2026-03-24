import Mathlib

open Finset BigOperators
open Topology
open BigOperators

structure SunspotEconomy where
  S : ℕ
  I : ℕ
  hS : 0 < S
  π : Fin S → ℝ
  π_pos : ∀ s, 0 < π s
  π_sum : ∑ s : Fin S, π s = 1
  u : Fin I → ℝ → ℝ
  u_strict_concave : ∀ i, StrictConcaveOn ℝ Set.univ (u i)

def Allocation (E : SunspotEconomy) := Fin E.S → Fin E.I → ℝ

noncomputable def expectedUtil (E : SunspotEconomy) (x : Allocation E) (i : Fin E.I) : ℝ :=
  ∑ s : Fin E.S, E.π s * E.u i (x s i)