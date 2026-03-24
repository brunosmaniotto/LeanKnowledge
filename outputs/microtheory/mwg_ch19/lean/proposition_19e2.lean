import Mathlib

open Finset BigOperators Matrix
open Topology
open BigOperators

structure RadnerEconomy where
  S : ℕ
  K : ℕ
  I : ℕ
  hS : 0 < S
  hK : 0 < K
  hI : 0 < I

variable {E : RadnerEconomy}

def completeMarkets (R : Matrix (Fin E.S) (Fin E.K) ℝ) : Prop :=
  R.rank = E.S

structure ADEquilibrium (E : RadnerEconomy) where
  x : Fin E.I → Fin E.S → ℝ
  p : Fin E.S → ℝ
  hp : ∀ s, 0 < p s
  budget : ∀ i, ∑ s : Fin E.S, p s * x i s = 0

structure RadnerEquilibrium (E : RadnerEconomy) (R : Matrix (Fin E.S) (Fin E.K) ℝ) where
  x : Fin E.I → Fin E.S → ℝ
  z : Fin E.I → Fin E.K → ℝ
  q : Fin E.K → ℝ
  p : Fin E.S → ℝ
  spotBudget : ∀ i s, p s * x i s = ∑ k : Fin E.K, R s k * z i k
  assetBudget : ∀ i, ∑ k : Fin E.K, q k * z i k = 0
  marketClearing : ∀ k, ∑ i : Fin E.I, z i k = 0