import Mathlib

variable {S T : Type*} [Semigroup S] [Semigroup T]

def prod_fin {n : ℕ} (hn : n ≥ 1) (s : Fin n → S) : S :=
  match n, hn with
  | 1, _ => s 0
  | k+2, h =>
    have : k+1 ≥ 1 := by omega
    prod_fin this (s ∘ Fin.castSucc) * s (Fin.last (k+1))