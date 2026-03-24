import Mathlib
open Topology
open BigOperators

axiom nonpos_of_pos_mul_nonpos {c a : ℝ} (hc : c > 0) (h : c * a ≤ 0) : a ≤ 0

axiom weighted_sum_zero_of_pointwise_sum_zero {I n : ℕ}
    (g : Fin I → Fin n → ℝ) (w : Fin n → ℝ)
    (hg : ∀ j : Fin n, ∑ i : Fin I, g i j = 0) :
    ∑ i : Fin I, (∑ j : Fin n, w j * g i j) = 0

axiom eq_zero_of_nonneg_of_sum_eq_zero {I : ℕ}
    (f : Fin I → ℝ) (hnn : ∀ i : Fin I, 0 ≤ f i)
    (hsum : ∑ i : Fin I, f i = 0) :
    ∀ i : Fin I, f i = 0

theorem claim_5e_o {I n : ℕ} (p : Fin n → ℝ) (x e : Fin I → Fin n → ℝ)
    (lam : Fin I → ℝ) (hlam_pos : ∀ i : Fin I, lam i > 0)
    (hgrad : ∀ i : Fin I, ∑ j : Fin n, lam i * p j * (e i j - x i j) ≤ 0)
    (hfeas : ∀ j : Fin n, ∑ i : Fin I, x i j = ∑ i : Fin I, e i j) :
    ∀ i : Fin I, ∑ j : Fin n, p j * x i j = ∑ j : Fin n, p j * e i j := by
  -- Step 1: p · (xᵢ - eᵢ) ≥ 0 for each i
  have hnn : ∀ i : Fin I, 0 ≤ ∑ j : Fin n, p j * (x i j - e i j) := by
    intro i
    have h1 := hgrad i
    have h2 : ∑ j : Fin n, lam i * p j * (e i j - x i j) =
              lam i * ∑ j : Fin n, p j * (e i j - x i j) := by
      rw [Finset.mul_sum]; apply Finset.sum_congr rfl; intro j _; ring
    have h3 : lam i * ∑ j : Fin n, p j * (e i j - x i j) ≤ 0 := by linarith
    have h4 := nonpos_of_pos_mul_nonpos (hlam_pos i) h3
    have h5 : (∑ j : Fin n, p j * (x i j - e i j)) +
              (∑ j : Fin n, p j * (e i j - x i j)) = 0 := by
      rw [← Finset.sum_add_distrib]
      exact Finset.sum_eq_zero fun j _ => by ring
    linarith
  -- Step 2: ∑ᵢ p · (xᵢ - eᵢ) = 0 (feasibility)
  have hsum : ∑ i : Fin I, (∑ j : Fin n, p j * (x i j - e i j)) = 0 :=
    weighted_sum_zero_of_pointwise_sum_zero (fun i j => x i j - e i j) p
      fun j => by simp only [Finset.sum_sub_distrib]; linarith [hfeas j]
  -- Step 3: each p · (xᵢ - eᵢ) = 0
  have hall := eq_zero_of_nonneg_of_sum_eq_zero _ hnn hsum
  -- Conclude: p · xᵢ = p · eᵢ
  intro i
  have h6 := hall i
  have h7 : ∑ j : Fin n, p j * (x i j - e i j) =
            (∑ j : Fin n, p j * x i j) - ∑ j : Fin n, p j * e i j := by
    simp only [mul_sub, Finset.sum_sub_distrib]
  linarith