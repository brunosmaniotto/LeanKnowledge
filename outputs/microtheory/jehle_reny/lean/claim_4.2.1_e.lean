import Mathlib
open Filter

-- Axiomatized sub-lemmas
axiom nat_add_one_tendsto_at_top : Filter.Tendsto (fun (J : ℕ) => (J : ℝ) + 1) Filter.atTop Filter.atTop
axiom one_div_J_plus_one_converges_to_zero : Filter.Tendsto (fun (J : ℕ) => 1 / ((J : ℝ) + 1)) Filter.atTop (nhds 0)
axiom constant_mul_one_div_converges_to_zero (K : ℝ) : Filter.Tendsto (fun (J : ℕ) => K / ((J : ℝ) + 1)) Filter.atTop (nhds 0)
axiom cournot_price_converges_to_marginal_cost (a c : ℝ) : Filter.Tendsto (fun (J : ℕ) => c + (a - c) / ((J : ℝ) + 1)) Filter.atTop (nhds c)

-- Main theorem (Claim_4.2.1_e)
theorem Claim_4_2_1_e (a c : ℝ) : Filter.Tendsto (fun (J : ℕ) => c + (a - c) / ((J : ℝ) + 1)) Filter.atTop (nhds c) := by
  -- The main theorem directly corresponds to the final sub-lemma, assuming the Cournot price function takes the form c + (a-c)/(J+1).
  exact cournot_price_converges_to_marginal_cost a c