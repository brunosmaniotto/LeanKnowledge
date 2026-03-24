import Mathlib

open Finset
open BigOperators

axiom nth_prime : ℕ → ℕ
axiom nth_prime_prime : ∀ n, Nat.Prime (nth_prime n)
axiom nth_prime_injective : Function.Injective nth_prime

structure URMState (b : ℕ) where
  ip : ℕ
  reg : Fin b → ℕ

def exponent (s : URMState b) (j : ℕ) : ℕ :=
  match j with
  | 0 => s.ip
  | j+1 => if h : j < b then s.reg ⟨j, h⟩ else 0

noncomputable def encodeState (s : URMState b) : ℕ :=
  ∏ j ∈ range (b + 1), (nth_prime j) ^ (exponent s j)

axiom encodeState_injective : ∀ (b : ℕ) (s1 s2 : URMState b), encodeState s1 = encodeState s2 → s1 = s2