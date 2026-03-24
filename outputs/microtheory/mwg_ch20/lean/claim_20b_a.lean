import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Claim_20B_a
    {n : ℕ} (T : ℕ) (hT : T < n)
    (u : Fin n → ℝ → ℝ)
    (c₁ c₂ : Fin n → ℝ)
    (V : (Fin n → ℝ) → ℝ)
    (hV : ∀ c, V c = ∑ i : Fin n, u i (c i)) :
    -- (1) ordering on future [T+1, n) is independent of past
    (∀ past₁ past₂ : Fin n → ℝ,
      (∀ i : Fin n, i.val > T → past₁ i = c₁ i) →
      (∀ i : Fin n, i.val > T → past₂ i = c₂ i) →
      (∀ i : Fin n, i.val ≤ T → past₁ i = past₂ i) →
      (V past₁ ≤ V past₂ ↔
       (∑ i : Fin n, if i.val > T then u i (c₁ i) else 0) ≤
       (∑ i : Fin n, if i.val > T then u i (c₂ i) else 0))) ∧
    -- (2) ordering on past [0, T] is independent of future
    (∀ fut₁ fut₂ : Fin n → ℝ,
      (∀ i : Fin n, i.val ≤ T → fut₁ i = c₁ i) →
      (∀ i : Fin n, i.val ≤ T → fut₂ i = c₂ i) →
      (∀ i : Fin n, i.val > T → fut₁ i = fut₂ i) →
      (V fut₁ ≤ V fut₂ ↔
       (∑ i : Fin n, if i.val ≤ T then u i (c₁ i) else 0) ≤
       (∑ i : Fin n, if i.val ≤ T then u i (c₂ i) else 0))) := by
  have split_sum : ∀ (f : Fin n → ℝ),
      ∑ i, f i = (∑ i, if i.val ≤ T then f i else 0) +
                 (∑ i, if i.val > T then f i else 0) := by
    intro f
    simp_rw [← Finset.sum_add_distrib]
    congr 1
    ext i
    by_cases hi : i.val ≤ T <;> simp [hi, Nat.not_le.mpr] <;> omega
  constructor
  · intro past₁ past₂ hfut₁ hfut₂ hpast_eq
    simp only [hV]
    have h1 : ∀ i : Fin n, i.val > T → u i (past₁ i) = u i (c₁ i) := by
      intro i hi; rw [hfut₁ i hi]
    have h2 : ∀ i : Fin n, i.val > T → u i (past₂ i) = u i (c₂ i) := by
      intro i hi; rw [hfut₂ i hi]
    have h3 : ∀ i : Fin n, i.val ≤ T → u i (past₁ i) = u i (past₂ i) := by
      intro i hi; rw [hpast_eq i hi]
    rw [split_sum (fun i => u i (past₁ i)), split_sum (fun i => u i (past₂ i))]
    have eq_past : (∑ i : Fin n, if i.val ≤ T then u i (past₁ i) else 0) =
                   (∑ i : Fin n, if i.val ≤ T then u i (past₂ i) else 0) := by
      congr 1; ext i; by_cases hi : i.val ≤ T <;> simp [hi, h3 i]
    have eq_fut₁ : (∑ i : Fin n, if i.val > T then u i (past₁ i) else 0) =
                    (∑ i : Fin n, if i.val > T then u i (c₁ i) else 0) := by
      congr 1; ext i; by_cases hi : i.val > T <;> simp [hi, h1 i]
    have eq_fut₂ : (∑ i : Fin n, if i.val > T then u i (past₂ i) else 0) =
                    (∑ i : Fin n, if i.val > T then u i (c₂ i) else 0) := by
      congr 1; ext i; by_cases hi : i.val > T <;> simp [hi, h2 i]
    rw [eq_past, eq_fut₁, eq_fut₂]
    constructor <;> intro h <;> linarith
  · intro fut₁ fut₂ hpast₁ hpast₂ hfut_eq
    simp only [hV]
    have h1 : ∀ i : Fin n, i.val ≤ T → u i (fut₁ i) = u i (c₁ i) := by
      intro i hi; rw [hpast₁ i hi]
    have h2 : ∀ i : Fin n, i.val ≤ T → u i (fut₂ i) = u i (c₂ i) := by
      intro i hi; rw [hpast₂ i hi]
    have h3 : ∀ i : Fin n, i.val > T → u i (fut₁ i) = u i (fut₂ i) := by
      intro i hi; rw [hfut_eq i hi]
    rw [split_sum (fun i => u i (fut₁ i)), split_sum (fun i => u i (fut₂ i))]
    have eq_fut : (∑ i : Fin n, if i.val > T then u i (fut₁ i) else 0) =
                  (∑ i : Fin n, if i.val > T then u i (fut₂ i) else 0) := by
      congr 1; ext i; by_cases hi : i.val > T <;> simp [hi, h3 i]
    have eq_past₁ : (∑ i : Fin n, if i.val ≤ T then u i (fut₁ i) else 0) =
                     (∑ i : Fin n, if i.val ≤ T then u i (c₁ i) else 0) := by
      congr 1; ext i; by_cases hi : i.val ≤ T <;> simp [hi, h1 i]
    have eq_past₂ : (∑ i : Fin n, if i.val ≤ T then u i (fut₂ i) else 0) =
                     (∑ i : Fin n, if i.val ≤ T then u i (c₂ i) else 0) := by
      congr 1; ext i; by_cases hi : i.val ≤ T <;> simp [hi, h2 i]
    rw [eq_fut, eq_past₁, eq_past₂]
    constructor <;> intro h <;> linarith