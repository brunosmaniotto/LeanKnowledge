import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Theorem 2.1 (Jehle & Reny): The indirect utility function u(x) = max{v ≥ 0 | x ∈ A(v)}
    derived from an expenditure function E is increasing, unbounded above, and quasiconcave. -/
theorem Theorem_2_1 {n : ℕ}
    (E : (Fin n → ℝ) → ℝ → ℝ)
    (P : Set (Fin n → ℝ))
    (u : (Fin n → ℝ) → ℝ)
    -- u(x) = max{v ≥ 0 | ∀ p ∈ P, p · x ≥ E(p, v)}
    (hu_max : ∀ x, (∀ p ∈ P, ∑ i, p i * x i ≥ E p (u x)) ∧
      ∀ v, 0 ≤ v → (∀ p ∈ P, ∑ i, p i * x i ≥ E p v) → v ≤ u x)
    -- E is nondecreasing in its utility argument
    (hE_mono : ∀ p ∈ P, Monotone (E p))
    -- Prices are strictly positive
    (hP_pos : ∀ p ∈ P, ∀ i : Fin n, 0 < p i)
    -- u is nonnegative-valued
    (hu_nonneg : ∀ x, 0 ≤ u x)
    -- For any utility level v ≥ 0, A(v) is nonempty (bundles can be made arbitrarily large)
    (hA_ne : ∀ v, 0 ≤ v → ∃ x : Fin n → ℝ, ∀ p ∈ P, ∑ i, p i * x i ≥ E p v) :
    -- (1) u is increasing, (2) unbounded above, (3) quasiconcave
    (∀ x₁ x₂ : Fin n → ℝ, (∀ i, x₂ i ≤ x₁ i) → u x₂ ≤ u x₁) ∧
    (∀ M : ℝ, ∃ x, M < u x) ∧
    (∀ x₁ x₂ : Fin n → ℝ, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      min (u x₁) (u x₂) ≤ u (fun i => t * x₁ i + (1 - t) * x₂ i)) := by
  refine ⟨?_, ?_, ?_⟩
  · -- Increasing: x₁ ≥ x₂ componentwise ⟹ p·x₁ ≥ p·x₂ ≥ E(p, u(x₂)) ⟹ u(x₁) ≥ u(x₂)
    intro x₁ x₂ hle
    apply (hu_max x₁).2 _ (hu_nonneg x₂)
    intro p hp
    calc ∑ i, p i * x₁ i
        ≥ ∑ i, p i * x₂ i :=
          sum_le_sum fun i _ => mul_le_mul_of_nonneg_left (hle i) (hP_pos p hp i).le
      _ ≥ E p (u x₂) := (hu_max x₂).1 p hp
  · -- Unbounded: A(max(M+1,0)) is nonempty, so ∃ x with u(x) ≥ max(M+1,0) > M
    intro M
    obtain ⟨x, hx⟩ := hA_ne (max (M + 1) 0) (le_max_right _ _)
    exact ⟨x, by linarith [(hu_max x).2 _ (le_max_right (M + 1) 0) hx,
                             le_max_left (M + 1) (0 : ℝ)]⟩
  · -- Quasiconcave: p·xᵗ = t(p·x₁) + (1-t)(p·x₂) ≥ E(p, min(u(x₁), u(x₂)))
    intro x₁ x₂ t ht0 ht1
    apply (hu_max (fun i => t * x₁ i + (1 - t) * x₂ i)).2 _
      (le_min (hu_nonneg x₁) (hu_nonneg x₂))
    intro p hp
    have hlin : ∀ i, p i * (t * x₁ i + (1 - t) * x₂ i) =
        t * (p i * x₁ i) + (1 - t) * (p i * x₂ i) := fun i => by ring
    simp_rw [hlin, sum_add_distrib, ← mul_sum]
    have h1 : E p (min (u x₁) (u x₂)) ≤ ∑ i, p i * x₁ i :=
      le_trans (hE_mono p hp (min_le_left _ _)) ((hu_max x₁).1 p hp)
    have h2 : E p (min (u x₁) (u x₂)) ≤ ∑ i, p i * x₂ i :=
      le_trans (hE_mono p hp (min_le_right _ _)) ((hu_max x₂).1 p hp)
    have hconv : t * E p (min (u x₁) (u x₂)) + (1 - t) * E p (min (u x₁) (u x₂)) =
        E p (min (u x₁) (u x₂)) := by ring
    have ht1' : 0 ≤ 1 - t := by linarith
    linarith [mul_le_mul_of_nonneg_left h1 ht0, mul_le_mul_of_nonneg_left h2 ht1']