import Mathlib
open Topology

theorem Claim_5C_e
    (p w_ℓ w_k Df_ℓ Df_k : ℝ)
    (hp : p ≠ 0)
    (hDf_k : Df_k ≠ 0)
    (foc_ℓ : p * Df_ℓ = w_ℓ)
    (foc_k : p * Df_k = w_k) :
    Df_ℓ = w_ℓ / p ∧ Df_ℓ / Df_k = w_ℓ / w_k := by
  have hw_k : w_k ≠ 0 := by
    intro h; rw [h] at foc_k; simp at foc_k
    exact foc_k.elim hp hDf_k
  constructor
  · rw [eq_div_iff hp]
    linarith
  · rw [div_eq_div_iff hDf_k hw_k]
    linear_combination Df_k * foc_ℓ - Df_ℓ * foc_k