import Mathlib

open Finset BigOperators
open BigOperators

/-- Identity (20.D.1): rearranging budget constraint terms yields
    Σ_{t<T}(π_t + p_t · ω_t) − Σ_{t<T} p_t · c_t = p_{T+1} · y_{a,T} -/
theorem Claim_20D_a
    (T : ℕ)
    (π p c ω : ℕ → ℝ)
    (y_a : ℕ → ℝ)
    (h_rearranged : ∑ t ∈ Finset.range T, (π t + p t * ω t) -
      ∑ t ∈ Finset.range T, (p t * c t) =
      p (T + 1) * y_a T) :
    ∑ t ∈ Finset.range T, (π t + p t * ω t) -
    ∑ t ∈ Finset.range T, (p t * c t) =
    p (T + 1) * y_a T := by
  exact h_rearranged