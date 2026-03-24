import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem walras_law_market_clearing
    (L : ℕ)
    (p z : Fin (L + 1) → ℝ)
    (hp_pos : ∀ i, 0 < p i)
    (hwalras : ∑ i, p i * z i = 0)
    (hclear : ∀ i : Fin (L + 1), i.val < L → z i = 0) :
    z (Fin.last L) = 0 := by
  have hzero : ∀ i, i ≠ Fin.last L → p i * z i = 0 := by
    intro i hi
    have hlt : i.val < L := by
      simp only [Ne, Fin.ext_iff, Fin.val_last] at hi
      omega
    rw [hclear i hlt, mul_zero]
  have hsum : ∑ i, p i * z i = p (Fin.last L) * z (Fin.last L) := by
    exact Finset.sum_eq_single (Fin.last L)
      (fun i _ hi => hzero i hi)
      (fun h => absurd (Finset.mem_univ _) h)
  rw [hsum] at hwalras
  exact (mul_eq_zero.mp hwalras).resolve_left (ne_of_gt (hp_pos _))