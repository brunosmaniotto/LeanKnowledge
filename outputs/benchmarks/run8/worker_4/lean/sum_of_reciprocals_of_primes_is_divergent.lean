import Mathlib
open Filter
open Real
open BigOperators

theorem exists_constant_sum_reciprocals_primes_divergent :
    ∃ (C : ℝ) (hC : C > 0), (∀ (n : ℕ) (hn : 1 ≤ n), (∑ p ∈ (Finset.range (n + 1)).filter Nat.Prime, 1 / (p : ℝ)) > Real.log (Real.log (n : ℝ)) - C) ∧
    Filter.Tendsto (fun n : ℕ => Real.log (Real.log (n : ℝ)) - 1/2) Filter.atTop Filter.atTop := by
  refine ⟨1/2, by norm_num, ?_, ?_⟩
  · intro n hn
    sorry
  · have h1 : Tendsto (fun n : ℕ => (n : ℝ)) atTop atTop := by
      rw [tendsto_atTop_atTop]
      intro b
      obtain ⟨N, hN⟩ := exists_nat_gt b
      use N
      intro n hn
      have : (N : ℝ) ≤ (n : ℝ) := by exact mod_cast hn
      linarith
    have h2 : Tendsto Real.log atTop atTop := Real.tendsto_log_atTop
    have h3 : Tendsto (fun n : ℕ => Real.log (n : ℝ)) atTop atTop := h2.comp h1
    have h4 : Tendsto (fun n : ℕ => Real.log (Real.log (n : ℝ))) atTop atTop := h2.comp h3
    rw [tendsto_atTop_atTop] at h4 ⊢
    intro b
    rcases h4 (b + 1/2) with ⟨N, hN⟩
    use N
    intro n hn
    have h := hN n hn
    linarith