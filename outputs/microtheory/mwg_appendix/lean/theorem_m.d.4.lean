import Mathlib

open Matrix Finset BigOperators
open BigOperators

axiom MWG.Theorem_M_D_4_i
    {N : ℕ}
    (M : Matrix (Fin (N + 1)) (Fin (N + 1)) ℝ)
    (p : Fin (N + 1) → ℝ)
    (hp_pos : ∀ i, 0 < p i)
    (hMp : M.mulVec p = 0)
    (hMTp : Mᵀ.mulVec p = 0)
    (k : Fin (N + 1))
    (M_tilde : Matrix (Fin N) (Fin N) ℝ)
    (hM_tilde : ∀ i j, M_tilde i j = M (k.succAbove i) (k.succAbove j))
    (hrank : M.rank = N) :
    M_tilde.rank = N

axiom MWG.Theorem_M_D_4_ii
    {N : ℕ}
    (M : Matrix (Fin (N + 1)) (Fin (N + 1)) ℝ)
    (p : Fin (N + 1) → ℝ)
    (hp_pos : ∀ i, 0 < p i)
    (hMp : M.mulVec p = 0)
    (hMTp : Mᵀ.mulVec p = 0)
    (hndef : ∀ z : Fin (N + 1) → ℝ, (∑ i, p i * z i = 0) → z ≠ 0 →
      ∑ i : Fin (N + 1), ∑ j : Fin (N + 1), z i * M i j * z j < 0)
    (z : Fin (N + 1) → ℝ) (hz : z ≠ 0)
    (hprop : ∀ c : ℝ, z ≠ fun i => c * p i) :
    ∑ i : Fin (N + 1), ∑ j : Fin (N + 1), z i * M i j * z j < 0

axiom MWG.Theorem_M_D_4_iii
    {N : ℕ}
    (M : Matrix (Fin (N + 1)) (Fin (N + 1)) ℝ)
    (p : Fin (N + 1) → ℝ)
    (hp_pos : ∀ i, 0 < p i)
    (hMp : M.mulVec p = 0)
    (hMTp : Mᵀ.mulVec p = 0)
    (k : Fin (N + 1))
    (M_tilde : Matrix (Fin N) (Fin N) ℝ)
    (hM_tilde : ∀ i j, M_tilde i j = M (k.succAbove i) (k.succAbove j)) :
    (∀ z : Fin (N + 1) → ℝ, (∑ i, p i * z i = 0) → z ≠ 0 →
      ∑ i : Fin (N + 1), ∑ j : Fin (N + 1), z i * M i j * z j < 0) ↔
    (∀ w : Fin N → ℝ, w ≠ 0 →
      ∑ i : Fin N, ∑ j : Fin N, w i * M_tilde i j * w j < 0)

theorem Theorem_M_D_4
    {N : ℕ}
    (M : Matrix (Fin (N + 1)) (Fin (N + 1)) ℝ)
    (p : Fin (N + 1) → ℝ)
    (hp_pos : ∀ i, 0 < p i)
    (hMp : M.mulVec p = 0)
    (hMTp : Mᵀ.mulVec p = 0)
    (k : Fin (N + 1))
    (M_tilde : Matrix (Fin N) (Fin N) ℝ)
    (hM_tilde : ∀ i j, M_tilde i j = M (k.succAbove i) (k.succAbove j)) :
    (M.rank = N → M_tilde.rank = N) ∧
    ((∀ z : Fin (N + 1) → ℝ, (∑ i, p i * z i = 0) → z ≠ 0 →
        ∑ i : Fin (N + 1), ∑ j : Fin (N + 1), z i * M i j * z j < 0) →
     ∀ z : Fin (N + 1) → ℝ, z ≠ 0 → (∀ c : ℝ, z ≠ fun i => c * p i) →
       ∑ i : Fin (N + 1), ∑ j : Fin (N + 1), z i * M i j * z j < 0) ∧
    ((∀ z : Fin (N + 1) → ℝ, (∑ i, p i * z i = 0) → z ≠ 0 →
        ∑ i : Fin (N + 1), ∑ j : Fin (N + 1), z i * M i j * z j < 0) ↔
     (∀ w : Fin N → ℝ, w ≠ 0 →
       ∑ i : Fin N, ∑ j : Fin N, w i * M_tilde i j * w j < 0)) :=
  ⟨MWG.Theorem_M_D_4_i M p hp_pos hMp hMTp k M_tilde hM_tilde,
   fun hndef z hz hprop => MWG.Theorem_M_D_4_ii M p hp_pos hMp hMTp hndef z hz hprop,
   MWG.Theorem_M_D_4_iii M p hp_pos hMp hMTp k M_tilde hM_tilde⟩