import Mathlib

open Finset BigOperators
open Topology
open BigOperators

noncomputable section

/-- Consumption-based asset pricing (MWG Claim 5.E).
    From FOC, Arrow security prices q_s = c · π_s · v'(x_s). Then:
    (1) price(α) = c · E[v' · α]
    (2) E[v'] > 0
    (3) Zero covariance (E[v'·α] = E[v']·E[α]) ⟹ price = c · E[v'] · E[α]
    Normalizing by c · E[v'] yields price = E[α] for assets independent of
    marginal utility. Positive covariance with v' (negative correlation with
    consumption under risk aversion) raises the price above expected value. -/
theorem claim_5e_af
    {S : ℕ} (hS : 0 < S)
    (π : Fin S → ℝ) (hπ_pos : ∀ s, 0 < π s)
    (hπ_sum : ∑ s : Fin S, π s = 1)
    (v' : Fin S → ℝ) (hv'_pos : ∀ s, 0 < v' s)
    (α : Fin S → ℝ)
    (c : ℝ) (hc : 0 < c)
    (q : Fin S → ℝ) (hq : ∀ s, q s = c * π s * v' s) :
    -- (1) Asset pricing formula
    (∑ s : Fin S, q s * α s = c * ∑ s : Fin S, π s * (v' s * α s)) ∧
    -- (2) Expected marginal utility is positive
    (0 < ∑ s : Fin S, π s * v' s) ∧
    -- (3) Zero covariance ⟹ expected-value pricing
    (∑ s : Fin S, π s * (v' s * α s) =
        (∑ s : Fin S, π s * v' s) * (∑ s : Fin S, π s * α s) →
     ∑ s : Fin S, q s * α s =
        c * (∑ s : Fin S, π s * v' s) * (∑ s : Fin S, π s * α s)) := by
  haveI : Nonempty (Fin S) := ⟨⟨0, hS⟩⟩
  have hEv' : 0 < ∑ s : Fin S, π s * v' s :=
    Finset.sum_pos (fun s _ => mul_pos (hπ_pos s) (hv'_pos s)) Finset.univ_nonempty
  have key : ∑ s : Fin S, q s * α s = c * ∑ s : Fin S, π s * (v' s * α s) := by
    have h : ∀ s : Fin S, q s * α s = c * (π s * (v' s * α s)) :=
      fun s => by rw [hq]; ring
    simp_rw [h, ← Finset.mul_sum]
  exact ⟨key, hEv', fun hcov => by rw [key, hcov]; ring⟩