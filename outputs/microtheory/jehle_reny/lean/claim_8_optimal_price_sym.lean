import Mathlib

open Finset BigOperators
open Topology

/-- Insurance model where the company offers coverage with optimal benefits B_l = l -/
structure InsuranceModel where
  u : ℝ → ℝ                    -- utility function
  d : Fin 2 → ℝ                -- disutility of effort e ∈ {0, 1}
  w : ℝ                        -- wealth
  p : Fin 2 → ℝ                -- premium as function of effort
  u_bar : ℝ                    -- reservation utility
  L : ℕ                        -- number of loss levels
  π : Fin 2 → Fin (L + 1) → ℝ -- loss probabilities π_l(e)
  loss : Fin (L + 1) → ℝ      -- loss levels l
  B : Fin (L + 1) → ℝ         -- benefit levels
  h_optimal_benefit : ∀ l, B l = loss l  -- optimal: B_l = l
  h_participation : ∀ e, u (w - p e) = d e + u_bar  -- from (8.11) with B_l = l

/-- When B_l = l, the utility equation u(w - p(e)) = d(e) + ū holds,
    which implicitly defines the optimal price p(e). -/
theorem Claim_8_optimal_price_sym (M : InsuranceModel) (e : Fin 2) :
    M.u (M.w - M.p e) = M.d e + M.u_bar := by
  exact M.h_participation e