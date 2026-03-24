import Mathlib

open BigOperators
open Topology

structure ObsData (n k : ℕ) where
  p : Fin n → Fin k → ℝ
  x : Fin n → Fin k → ℝ

def ObsData.R0 {n k : ℕ} (D : ObsData n k) (i j : Fin n) : Prop :=
  ∑ l : Fin k, D.p i l * D.x j l ≤ ∑ l : Fin k, D.p i l * D.x i l