import Mathlib

noncomputable section
open Finset BigOperators
open Topology
open BigOperators

variable {S : Type*} [Fintype S] [DecidableEq S]

structure Prior (S : Type*) [Fintype S] where
  pmf : S → ℝ
  nonneg : ∀ s, 0 ≤ pmf s
  sum_one : ∑ s : S, pmf s = 1

def eu (p : Prior S) (v : S → ℝ) : ℝ := ∑ s : S, p.pmf s * v s