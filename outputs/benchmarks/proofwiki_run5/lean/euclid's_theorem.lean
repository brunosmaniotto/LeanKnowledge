import Mathlib

open Finset
open BigOperators

theorem exists_prime_not_in_finite_set (s : Finset ℕ) (h : ∀ p ∈ s, Nat.Prime p) : ∃ q, Nat.Prime q ∧ q ∉ s := by
  let N := (∏ p ∈ s, p) + 1
  have hN_gt_one : 1 < N := by
    have hprod : 1 ≤ ∏ p ∈ s, p := by
      refine Finset.one_le_prod' fun p hp => ?_
      exact (Nat.Prime.one_lt (h p hp)).le
    omega
  rcases Nat.exists_prime_and_dvd (ne_of_gt hN_gt_one) with ⟨q, hq_prime, hq_dvd_N⟩
  have hq_not_mem : q ∉ s := by
    intro hq_mem
    have hq_dvd_prod : q ∣ ∏ p ∈ s, p :=
      Finset.dvd_prod_of_mem (fun p => p) hq_mem
    have hq_dvd1 : q ∣ 1 := (Nat.dvd_add_right hq_dvd_prod).mp hq_dvd_N
    have hq_le1 : q ≤ 1 := Nat.le_of_dvd (by norm_num) hq_dvd1
    have hq_gt1 : 1 < q := Nat.Prime.one_lt hq_prime
    linarith
  exact ⟨q, hq_prime, hq_not_mem⟩