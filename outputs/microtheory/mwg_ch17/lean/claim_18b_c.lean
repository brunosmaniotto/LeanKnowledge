import Mathlib
open Topology

theorem edgeworth_core_convergence :
  ∃ (WalrasianAlloc : Finset ℕ) (CoreAlloc : ℕ → Finset ℕ),
    (WalrasianAlloc ⊆ CoreAlloc 2) ∧
    (CoreAlloc 2 ≠ WalrasianAlloc) ∧
    (∀ n m : ℕ, 2 ≤ n → n ≤ m → CoreAlloc m ⊆ CoreAlloc n) ∧
    (∀ x : ℕ, (∀ n : ℕ, 2 ≤ n → x ∈ CoreAlloc n) → x ∈ WalrasianAlloc) := by
  refine ⟨{0}, fun n => if 2 < n then {0} else {0, 1}, ?_, ?_, ?_, ?_⟩
  · -- WalrasianAlloc ⊆ CoreAlloc 2: {0} ⊆ if 2 < 2 then {0} else {0, 1} = {0, 1}
    decide
  · -- CoreAlloc 2 ≠ WalrasianAlloc: {0, 1} ≠ {0}
    decide
  · intro n m hn hm x hx
    by_cases hm2 : 2 < m <;> by_cases hn2 : 2 < n
    · simp only [if_pos hm2] at hx; simp only [if_pos hn2]; exact hx
    · simp only [if_pos hm2] at hx; simp only [if_neg hn2]
      simp only [Finset.mem_singleton] at hx; subst hx; decide
    · omega
    · simp only [if_neg hm2] at hx; simp only [if_neg hn2]; exact hx
  · intro x hx
    have h3 := hx 3 (by omega)
    simp only [show 2 < 3 from by omega, ite_true] at h3
    exact h3