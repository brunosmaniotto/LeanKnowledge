import Mathlib

open BigOperators Finset
open Topology

/-- At an interior Lindahl equilibrium, the Samuelson optimality condition holds:
    the sum of marginal rates of substitution equals the marginal rate of transformation.
    This follows from combining consumer FOCs (MRS_i = p_{2i}/p_1) with the firm FOC
    (MRT = Σ_i p_{2i}/p_1). -/
theorem lindahl_samuelson_condition
    {I : Type*} [Fintype I] [DecidableEq I]
    (MRS : I → ℝ)  -- MRS^i_{21} for each consumer
    (MRT : ℝ)       -- MRT_{21}
    (p₁ : ℝ)        -- price of private good
    (p₂ : I → ℝ)    -- personalized Lindahl prices for public good
    (hp₁ : p₁ ≠ 0)
    -- Consumer FOC: each consumer's MRS equals their personalized price ratio
    (consumer_foc : ∀ i, MRS i = p₂ i / p₁)
    -- Firm FOC: MRT equals sum of personalized price ratios
    (firm_foc : MRT = ∑ i : I, p₂ i / p₁) :
    ∑ i : I, MRS i = MRT := by
  rw [firm_foc]
  congr 1
  ext i
  exact consumer_foc i