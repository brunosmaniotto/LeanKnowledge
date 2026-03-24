import Mathlib

open Finset BigOperators
open Topology
open BigOperators

structure Firm (J : Type*) where
  cost : ℝ → ℝ

noncomputable def firmProfit (p : ℝ) (c : ℝ → ℝ) (q : ℝ) : ℝ := p * q - c q

theorem Claim_5E_c {n : ℕ} (firms : Fin n → Firm (Fin n)) (p : ℝ)
    (q : Fin n → ℝ)
    (hProfit : ∀ j, ∀ q' : ℝ, firmProfit p (firms j).cost (q j) ≥ firmProfit p (firms j).cost q')
    : ∀ (alloc : Fin n → ℝ), ∑ j, alloc j = ∑ j, q j →
        ∑ j, (firms j).cost (q j) ≤ ∑ j, (firms j).cost (alloc j) := by
  intro alloc halloc
  have key : ∀ j, p * q j - (firms j).cost (q j) ≥ p * alloc j - (firms j).cost (alloc j) :=
    fun j => hProfit j (alloc j)
  have hsum : ∑ j, (p * q j - (firms j).cost (q j)) ≥
              ∑ j, (p * alloc j - (firms j).cost (alloc j)) :=
    Finset.sum_le_sum fun j _ => key j
  simp only [Finset.sum_sub_distrib, ← Finset.mul_sum] at hsum
  have hpeq : p * ∑ i, alloc i = p * ∑ i, q i := by rw [halloc]
  linarith