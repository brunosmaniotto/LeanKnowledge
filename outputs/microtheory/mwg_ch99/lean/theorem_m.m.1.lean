import Mathlib
open BigOperators
open Topology

axiom bilinear_sum_swap {n m : ℕ} (A : Fin m → Fin n → ℝ) (x : Fin n → ℝ) (lam : Fin m → ℝ) : ∑ j : Fin m, lam j * (∑ i : Fin n, A j i * x i) = ∑ i : Fin n, (∑ j : Fin m, A j i * lam j) * x i
axiom weak_duality {n m : ℕ} (A : Fin m → Fin n → ℝ) (f : Fin n → ℝ) (c : Fin m → ℝ) (x : Fin n → ℝ) (lam : Fin m → ℝ) (hx_nn : ∀ i, 0 ≤ x i) (hlam_nn : ∀ j, 0 ≤ lam j) (hAx : ∀ j, ∑ i, A j i * x i ≤ c j) (hATlam : ∀ i, f i ≤ ∑ j, A j i * lam j) : ∑ i, f i * x i ≤ ∑ j, c j * lam j
axiom cs_value_equality {n m : ℕ} (A : Fin m → Fin n → ℝ) (f : Fin n → ℝ) (c : Fin m → ℝ) (x : Fin n → ℝ) (lam : Fin m → ℝ) (hlam_nn : ∀ j, 0 ≤ lam j) (hx_nn : ∀ i, 0 ≤ x i) (hAx : ∀ j, ∑ i, A j i * x i ≤ c j) (hATlam : ∀ i, f i ≤ ∑ j, A j i * lam j) (hcs_primal : ∀ j, lam j * (c j - ∑ i, A j i * x i) = 0) (hcs_dual : ∀ i, (∑ j, A j i * lam j - f i) * x i = 0) : ∑ j, c j * lam j = ∑ i, f i * x i
axiom kkt_multipliers_exist {n m : ℕ} (A : Fin m → Fin n → ℝ) (f : Fin n → ℝ) (c : Fin m → ℝ) (x_opt : Fin n → ℝ) (hx_nn : ∀ i, 0 ≤ x_opt i) (hAx : ∀ j, ∑ i, A j i * x_opt i ≤ c j) (hopt : ∀ x : Fin n → ℝ, (∀ i, 0 ≤ x i) → (∀ j, ∑ i, A j i * x i ≤ c j) → ∑ i, f i * x i ≤ ∑ i, f i * x_opt i) : ∃ lam : Fin m → ℝ, (∀ j, 0 ≤ lam j) ∧ (∀ i, f i ≤ ∑ j, A j i * lam j) ∧ (∀ j, lam j * (c j - ∑ i, A j i * x_opt i) = 0) ∧ (∀ i, (∑ j, A j i * lam j - f i) * x_opt i = 0)

theorem lp_duality {n m : ℕ} (A : Fin m → Fin n → ℝ) (f : Fin n → ℝ) (c : Fin m → ℝ)
    (x_opt : Fin n → ℝ) (hx_nn : ∀ i, 0 ≤ x_opt i)
    (hAx : ∀ j, ∑ i, A j i * x_opt i ≤ c j)
    (hopt : ∀ x : Fin n → ℝ, (∀ i, 0 ≤ x i) → (∀ j, ∑ i, A j i * x i ≤ c j) →
      ∑ i, f i * x i ≤ ∑ i, f i * x_opt i) :
    ∃ lam : Fin m → ℝ,
      (∀ j, 0 ≤ lam j) ∧
      (∀ i, f i ≤ ∑ j, A j i * lam j) ∧
      (∀ μ : Fin m → ℝ, (∀ j, 0 ≤ μ j) → (∀ i, f i ≤ ∑ j, A j i * μ j) →
        ∑ j, c j * lam j ≤ ∑ j, c j * μ j) ∧
      ∑ j, c j * lam j = ∑ i, f i * x_opt i := by
  obtain ⟨lam, hlam_nn, hATlam, hcs_p, hcs_d⟩ := kkt_multipliers_exist A f c x_opt hx_nn hAx hopt
  refine ⟨lam, hlam_nn, hATlam, ?_, ?_⟩
  · intro μ hμ_nn hATμ
    rw [cs_value_equality A f c x_opt lam hlam_nn hx_nn hAx hATlam hcs_p hcs_d]
    exact weak_duality A f c x_opt μ hx_nn hμ_nn hAx hATμ
  · exact cs_value_equality A f c x_opt lam hlam_nn hx_nn hAx hATlam hcs_p hcs_d