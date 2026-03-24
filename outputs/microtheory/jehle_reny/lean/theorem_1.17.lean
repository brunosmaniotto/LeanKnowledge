import Mathlib

open Finset BigOperators
open Topology
open BigOperators

noncomputable section

theorem engel_cournot_aggregation
    {n : ℕ} (p x : Fin n → ℝ) (y : ℝ) (hy : y ≠ 0) (hx : ∀ i, x i ≠ 0)
    (s η : Fin n → ℝ) (ε : Fin n → Fin n → ℝ)
    (dxdy : Fin n → ℝ) (dxdp : Fin n → Fin n → ℝ)
    (hs : ∀ i, s i = p i * x i / y)
    (hη : ∀ i, η i = dxdy i * y / x i)
    (hε : ∀ i j, ε i j = dxdp i j * p j / x i)
    (hdy : ∑ i : Fin n, p i * dxdy i = 1)
    (hdp : ∀ j, ∑ i : Fin n, p i * dxdp i j = -x j) :
    (∑ i : Fin n, s i * η i = 1) ∧
    (∀ j : Fin n, ∑ i : Fin n, s i * ε i j = -s j) := by
  constructor
  · -- Engel aggregation: Σ sᵢηᵢ = 1
    have h : ∀ i, s i * η i = p i * dxdy i := by
      intro i; have := hx i; rw [hs i, hη i]; field_simp
    simp_rw [h]; exact hdy
  · -- Cournot aggregation: Σ sᵢεᵢⱼ = −sⱼ
    intro j
    have h : ∀ i, s i * ε i j = (p j / y) * (p i * dxdp i j) := by
      intro i; have := hx i; rw [hs i, hε i j]; field_simp
    simp_rw [h]; rw [← Finset.mul_sum, hdp j, hs j]; ring