import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Properties of the indirect utility function v(p,y) = max u(x) s.t. p·x ≤ y.
    (1) continuity follows from the theorem of the maximum (Theorem A2.21),
    (3) increasing in y is immediate from budget set monotonicity,
    (6) Roy's identity follows from the envelope theorem.
    Here we prove the budget-set algebra for (2), (4), (5). -/
theorem Theorem_1_6 {n : ℕ} :
    -- (2) Homogeneity of degree zero: scaling (p,y) by t>0 preserves budget constraint
    (∀ (p x : Fin n → ℝ) (y t : ℝ), t > 0 →
      (∑ i : Fin n, (t * p i) * x i ≤ t * y ↔ ∑ i : Fin n, p i * x i ≤ y)) ∧
    -- (4) Decreasing in p: lower prices expand budget set for nonneg consumption
    (∀ (p₀ p₁ x : Fin n → ℝ) (y : ℝ),
      (∀ i, 0 ≤ x i) → (∀ i, p₁ i ≤ p₀ i) →
      ∑ i : Fin n, p₀ i * x i ≤ y → ∑ i : Fin n, p₁ i * x i ≤ y) ∧
    -- (5) Quasiconvexity: feasibility at convex combination ⟹ feasibility at an endpoint
    (∀ (p₁ p₂ x : Fin n → ℝ) (y₁ y₂ t : ℝ),
      0 ≤ t → t ≤ 1 →
      ∑ i : Fin n, (t * p₁ i + (1 - t) * p₂ i) * x i ≤ t * y₁ + (1 - t) * y₂ →
      ∑ i : Fin n, p₁ i * x i ≤ y₁ ∨ ∑ i : Fin n, p₂ i * x i ≤ y₂) := by
  refine ⟨?_, ?_, ?_⟩
  -- (2) Homogeneity of degree zero
  · intro p x y t ht
    have key : ∑ i : Fin n, (t * p i) * x i = t * ∑ i : Fin n, p i * x i := by
      simp_rw [mul_assoc]; rw [← Finset.mul_sum]
    constructor
    · intro h; rw [key] at h; nlinarith
    · intro h; rw [key]; nlinarith
  -- (4) Decreasing in p
  · intro p₀ p₁ x y hx hp h
    calc ∑ i : Fin n, p₁ i * x i
        ≤ ∑ i : Fin n, p₀ i * x i :=
          Finset.sum_le_sum fun i _ => mul_le_mul_of_nonneg_right (hp i) (hx i)
      _ ≤ y := h
  -- (5) Quasiconvexity by contradiction
  · intro p₁ p₂ x y₁ y₂ t ht ht' hbudget
    by_contra hcon
    push_neg at hcon
    obtain ⟨h1, h2⟩ := hcon
    have expand : ∑ i : Fin n, (t * p₁ i + (1 - t) * p₂ i) * x i =
        t * ∑ i : Fin n, p₁ i * x i + (1 - t) * ∑ i : Fin n, p₂ i * x i := by
      trans ∑ i : Fin n, (t * (p₁ i * x i) + (1 - t) * (p₂ i * x i))
      · exact Finset.sum_congr rfl fun i _ => by ring
      rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum]
    rw [expand] at hbudget
    set s₁ := ∑ i : Fin n, p₁ i * x i
    set s₂ := ∑ i : Fin n, p₂ i * x i
    have hge1 : 0 ≤ t * (s₁ - y₁) := mul_nonneg ht (by linarith)
    have hge2 : 0 ≤ (1 - t) * (s₂ - y₂) := mul_nonneg (by linarith) (by linarith)
    have hle : t * (s₁ - y₁) + (1 - t) * (s₂ - y₂) ≤ 0 := by nlinarith
    have heq1 : t * (s₁ - y₁) = 0 := by linarith
    have heq2 : (1 - t) * (s₂ - y₂) = 0 := by linarith
    rcases mul_eq_zero.mp heq1 with ht0 | hc1
    · rcases mul_eq_zero.mp heq2 with hc2 | hc3
      · linarith
      · linarith
    · linarith