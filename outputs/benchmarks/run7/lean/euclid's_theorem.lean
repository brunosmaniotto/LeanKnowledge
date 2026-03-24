import Mathlib

open Finset
open BigOperators

theorem euclid_infinite_primes (s : Finset ℕ) (h : ∀ p ∈ s, Nat.Prime p) : ∃ q, Nat.Prime q ∧ q ∉ s := by
  set n := (∏ p ∈ s, p) + 1 with hn_def
  have h_prod_pos : 0 < ∏ p ∈ s, p := by
    apply Finset.prod_pos
    intro p hp
    exact (h p hp).pos
  have hn : n ≥ 2 := by linarith
  have h_n_ne_one : n ≠ 1 := by omega
  obtain ⟨q, hq_prime, hq_dvd⟩ := Nat.exists_prime_and_dvd h_n_ne_one
  have hq_not_mem : q ∉ s := by
    intro hq_mem
    have hq_dvd_prod : q ∣ ∏ p ∈ s, p :=
      Finset.dvd_prod_of_mem (fun p => p) hq_mem
    have hq_dvd_one : q ∣ 1 := by
      rw [hn_def] at hq_dvd
      exact (Nat.dvd_add_right hq_dvd_prod).mp hq_dvd
    have hq_ge_2 : 1 < q := hq_prime.one_lt
    have : q ≤ 1 := Nat.le_of_dvd (by norm_num) hq_dvd_one
    linarith
  exact ⟨q, hq_prime, hq_not_mem⟩