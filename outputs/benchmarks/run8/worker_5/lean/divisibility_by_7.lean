import Mathlib

open Finset
open BigOperators

theorem div_by_seven_iff (d : ℕ → ℤ) (n : ℕ) :
    7 ∣ (∑ i ∈ range n, (10 : ℤ) ^ i * d i) ↔ 7 ∣ (∑ i ∈ range n, (3 : ℤ) ^ i * d i) := by
  have h10 : (10 : ℤ) ≡ 3 [ZMOD (7 : ℤ)] := by decide
  have hpow : ∀ i, (10 : ℤ) ^ i ≡ (3 : ℤ) ^ i [ZMOD (7 : ℤ)] := fun i => h10.pow i
  have hterm : ∀ i, (10 : ℤ) ^ i * d i ≡ (3 : ℤ) ^ i * d i [ZMOD (7 : ℤ)] := fun i => (hpow i).mul_right (d i)
  have hsum : (∑ i ∈ range n, (10 : ℤ) ^ i * d i) ≡ (∑ i ∈ range n, (3 : ℤ) ^ i * d i) [ZMOD (7 : ℤ)] :=
    Int.ModEq.sum (fun i _ => hterm i)
  constructor
  · intro hX
    rw [← Int.modEq_zero_iff_dvd] at hX ⊢
    exact hsum.symm.trans hX
  · intro hS
    rw [← Int.modEq_zero_iff_dvd] at hS ⊢
    exact hsum.trans hS