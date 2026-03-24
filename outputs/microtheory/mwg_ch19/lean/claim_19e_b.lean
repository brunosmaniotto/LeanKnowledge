import Mathlib

open Finset BigOperators
open Topology

variable {S J : ℕ}

structure AssetMarket (S J : ℕ) where
  returns : Matrix (Fin J) (Fin S) ℝ

noncomputable def AssetMarket.transferSpan (M : AssetMarket S J) : Submodule ℝ (Fin S → ℝ) :=
  Submodule.span ℝ (Set.range (fun j => fun s => M.returns j s))

def AssetMarket.isRedundant (M : AssetMarket S (J + 1)) (k : Fin (J + 1)) : Prop :=
  (fun s => M.returns k s) ∈ Submodule.span ℝ
    (Set.range (fun j : {i : Fin (J + 1) // i ≠ k} => fun s => M.returns j.val s))