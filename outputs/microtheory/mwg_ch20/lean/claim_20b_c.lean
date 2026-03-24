import Mathlib
open Filter

theorem Claim_20B_c (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ < 1) :
    Filter.Tendsto (fun T : ℕ => δ ^ T) Filter.atTop (nhds 0) := by
  exact tendsto_pow_atTop_nhds_zero_of_lt_one hδ0 hδ1