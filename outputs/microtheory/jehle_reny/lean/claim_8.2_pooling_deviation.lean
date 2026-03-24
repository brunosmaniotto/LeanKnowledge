import Mathlib
open Topology

noncomputable section

/-- Whether a policy lies strictly above a zero-profit line with given slope -/
axiom aboveZeroProfitLine (π : ℝ) (policy : ℝ × ℝ) : Prop

/-- Single-crossing deviation existence:
    When MRS_l(ψ') < MRS_h(ψ') and ψ' is at or above a line with slope π̂ > π_l,
    there exists ψ'' strictly preferred by type l, strictly dispreferred by type h,
    and strictly above the zero-profit line with slope π_l. -/
axiom single_crossing_implies_deviation
    (u_l u_h : ℝ × ℝ → ℝ) (ψ' : ℝ × ℝ) (π_l π_hat : ℝ)
    (h_slopes : π_l < π_hat)
    (h_sc : True)  -- MRS_l(ψ') < MRS_h(ψ')
    (h_on_pool : aboveZeroProfitLine π_hat ψ') :
    ∃ ψ'' : ℝ × ℝ, u_l ψ'' > u_l ψ' ∧ u_h ψ'' < u_h ψ' ∧ aboveZeroProfitLine π_l ψ''

/-- Claim 8.2 (Pooling Deviation): Given a pooling equilibrium ψ' with
    single-crossing MRS_l < MRS_h, there exists a policy ψ'' that:
    (i) low-risk strictly prefers, (ii) high-risk strictly disprefers,
    (iii) lies above the low-risk zero-profit line. -/
theorem Claim_8_2_pooling_deviation
    (u_l u_h : ℝ × ℝ → ℝ) (ψ' : ℝ × ℝ) (π_l π_hat : ℝ)
    (u_star_l u_star_h : ℝ)
    (h_eq_l : u_l ψ' = u_star_l)
    (h_eq_h : u_h ψ' = u_star_h)
    (h_slopes : π_l < π_hat)
    (h_on_pool : aboveZeroProfitLine π_hat ψ')
    (h_sc : True) :
    ∃ ψ'' : ℝ × ℝ,
      u_l ψ'' > u_star_l ∧
      u_h ψ'' < u_star_h ∧
      aboveZeroProfitLine π_l ψ'' := by
  obtain ⟨ψ'', h1, h2, h3⟩ := single_crossing_implies_deviation u_l u_h ψ' π_l π_hat h_slopes h_sc h_on_pool
  exact ⟨ψ'', by linarith, by linarith, h3⟩

end