import Mathlib
open BigOperators
open Finset
open Topology

structure WalrasianEquilibrium where
  price : ℕ → ℝ
  consumption : ℕ → ℝ
  wealth : ℝ
  utility : (ℕ → ℝ) → ℝ
  price_pos_zero : 0 < price 0
  strict_mono : ∀ c c' : ℕ → ℝ, (∀ t, c t ≤ c' t) → (∃ t, c t < c' t) → utility c < utility c'
  budget_feasible : ∀ n : ℕ, ∑ t ∈ Finset.range n, price t * consumption t ≤ wealth
  optimal : ∀ c' : ℕ → ℝ, (∀ n, ∑ t ∈ Finset.range n, price t * c' t ≤ wealth) → utility c' ≤ utility consumption

theorem walrasian_budget_binds (W : WalrasianEquilibrium) :
    ¬ (∃ ε > 0, ∀ n : ℕ, ∑ t ∈ Finset.range n, W.price t * W.consumption t ≤ W.wealth - ε) := by
  intro ⟨ε, hε, hslack⟩
  set δ := ε / W.price 0 with hδ_def
  have hδ : δ > 0 := div_pos hε W.price_pos_zero
  let c' : ℕ → ℝ := Function.update W.consumption 0 (W.consumption 0 + δ)
  have hle : ∀ t, W.consumption t ≤ c' t := by
    intro t
    simp only [c', Function.update]
    split
    · subst_vars; linarith
    · exact le_refl _
  have hlt : ∃ t, W.consumption t < c' t :=
    ⟨0, by simp [c', Function.update_self, hδ]⟩
  have hutility : W.utility W.consumption < W.utility c' :=
    W.strict_mono W.consumption c' hle hlt
  have hfeas : ∀ m : ℕ, ∑ t ∈ Finset.range m, W.price t * c' t ≤ W.wealth := by
    intro m
    have hdiff : ∀ t, W.price t * c' t = W.price t * W.consumption t +
        (if t = 0 then W.price 0 * δ else 0) := by
      intro t
      simp only [c', Function.update]
      split
      · subst_vars; ring
      · simp
    have hsum_eq : ∑ t ∈ Finset.range m, W.price t * c' t =
        (∑ t ∈ Finset.range m, W.price t * W.consumption t) +
        ∑ t ∈ Finset.range m, (if t = 0 then W.price 0 * δ else 0) := by
      rw [← Finset.sum_add_distrib]
      congr 1; ext t; exact hdiff t
    have hcond_sum : ∑ t ∈ Finset.range m, (if t = 0 then W.price 0 * δ else 0) ≤
        W.price 0 * δ := by
      by_cases hm : m = 0
      · subst hm; simp; exact mul_nonneg (le_of_lt W.price_pos_zero) (le_of_lt hδ)
      · have h0m : 0 ∈ Finset.range m := Finset.mem_range.mpr (Nat.pos_of_ne_zero hm)
        rw [← Finset.add_sum_erase _ _ h0m]
        simp only [if_true]
        have : ∑ t ∈ (Finset.range m).erase 0, (if t = 0 then W.price 0 * δ else 0) = 0 := by
          apply Finset.sum_eq_zero
          intro t ht
          have : t ≠ 0 := Finset.ne_of_mem_erase ht
          simp [this]
        linarith
    have hpδ : W.price 0 * δ = ε := by
      rw [hδ_def]
      rw [mul_div_cancel₀]
      exact ne_of_gt W.price_pos_zero
    linarith [hslack m]
  linarith [W.optimal c' hfeas]