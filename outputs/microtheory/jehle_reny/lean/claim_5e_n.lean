import Mathlib

open BigOperators Finset
open Topology

theorem Claim_5e_n
    {I : ℕ} [NeZero I] {n : ℕ}
    (grad : Fin I → Fin n → ℝ)
    (hgrad_pos : ∀ i j, grad i j > 0)
    (μ : Fin I → ℝ)
    (hμ_pos : ∀ i, μ i > 0)
    (h_foc : ∀ i j, μ i * grad i j = μ 0 * grad 0 j) :
    ∃ (p : Fin n → ℝ) (lam : Fin I → ℝ),
      (∀ j, p j > 0) ∧
      (∀ i, lam i > 0) ∧
      (∀ i j, grad i j = lam i * p j) := by
  refine ⟨grad 0, fun i => μ 0 / μ i, hgrad_pos 0,
    fun i => div_pos (hμ_pos 0) (hμ_pos i), ?_⟩
  intro i j
  have hμi_ne : (μ i) ≠ 0 := ne_of_gt (hμ_pos i)
  have h := h_foc i j
  field_simp
  linear_combination h