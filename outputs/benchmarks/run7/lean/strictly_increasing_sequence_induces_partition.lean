import Mathlib
open Finset
open Nat

variable (n : ℕ) (r : Fin (n + 1) → ℕ) (h_strict : StrictMono r)

/-- The interval `[r_{k-1} + 1, r_k]` for `k ∈ [1, n]`, else empty. -/
def A (k : ℕ) : Finset ℕ :=
  if h : k ∈ Icc (1 : ℕ) n then
    let k0 : Fin (n + 1) := ⟨k - 1, by
      have : k ≤ n := (mem_Icc.1 h).right
      omega⟩
    let k1 : Fin (n + 1) := ⟨k, by
      have : k ≤ n := (mem_Icc.1 h).right
      omega⟩
    Icc (r k0 + 1) (r k1)
  else ∅