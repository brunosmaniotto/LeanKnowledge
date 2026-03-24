import Mathlib

open BigOperators Finset
set_option linter.unusedVariables false

variable {I K : Type*} [Fintype I] [Fintype K]

structure RadnerEq (u : I → (K → ℝ) → ℝ) where
  q : K → ℝ
  z : I → K → ℝ
  clear : ∀ k, ∑ i : I, z i k = 0
  wopt : ∀ i z', u i z' ≥ u i (z i) → ∑ k : K, q k * z' k ≥ ∑ k : K, q k * z i k
  sopt : ∀ i z', u i z' > u i (z i) → ∑ k : K, q k * z' k > ∑ k : K, q k * z i k

theorem Proposition_19F1 (u : I → (K → ℝ) → ℝ) (eq : RadnerEq u) :
    ¬∃ z' : I → K → ℝ,
      (∀ k, ∑ i : I, z' i k = 0) ∧
      (∀ i, u i (z' i) ≥ u i (eq.z i)) ∧
      (∃ i, u i (z' i) > u i (eq.z i)) := by
  intro ⟨z', hclear, hge, i₀, hgt⟩
  have hcs := eq.sopt i₀ (z' i₀) hgt
  have hcw : ∀ i, ∑ k : K, eq.q k * z' i k ≥ ∑ k : K, eq.q k * eq.z i k :=
    fun i => eq.wopt i (z' i) (hge i)
  have hkey : ∑ i : I, ∑ k : K, eq.q k * eq.z i k < ∑ i : I, ∑ k : K, eq.q k * z' i k :=
    sum_lt_sum (fun i _ => hcw i) ⟨i₀, mem_univ _, hcs⟩
  have hmc : ∀ f : I → K → ℝ, (∀ k, ∑ i : I, f i k = 0) →
      ∑ i : I, ∑ k : K, eq.q k * f i k = 0 := fun f hf => by
    rw [sum_comm]; simp [← mul_sum, hf]
  linarith [hmc eq.z eq.clear, hmc z' hclear]