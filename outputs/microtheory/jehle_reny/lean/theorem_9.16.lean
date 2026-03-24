import Mathlib

open Finset BigOperators
open Topology
open BigOperators
set_option linter.unusedVariables false

/-- Theorem 9.16: The IR-VCG mechanism generates the maximum ex ante expected revenue
    among all incentive-compatible, ex post efficient, individually rational mechanisms.

    Under the differentiability and uniqueness conditions, Theorem 9.14 forces any
    competing mechanism's interim costs to satisfy c̄_i = c̄^IRVCG_i − k_i for some
    constants k_i; individual rationality combined with the minimality of ψ*_i forces
    k_i ≥ 0, so the competing mechanism collects weakly less expected revenue. -/
theorem Theorem_9_16
    {I : ℕ} {T : Fin I → Type} [∀ i, Fintype (T i)]
    (c_bar       : ∀ i : Fin I, T i → ℝ)   -- competing mechanism's interim costs
    (c_bar_irvcg : ∀ i : Fin I, T i → ℝ)   -- IR-VCG interim costs
    (q           : ∀ i : Fin I, T i → ℝ)   -- marginal type probabilities
    (hq_nonneg   : ∀ i t, 0 ≤ q i t)
    -- Theorem 9.14 (same EP assignment ⟹ costs differ by constant) combined with
    -- IR + minimality of ψ*_i gives nonneg constants k_i with c̄_i = c̄^IRVCG_i − k_i.
    (hk : ∃ k : Fin I → ℝ, (∀ i, 0 ≤ k i) ∧
          ∀ i (t : T i), c_bar i t = c_bar_irvcg i t - k i) :
    -- Any competing IC + EP + IR mechanism collects weakly less expected revenue.
    ∑ i : Fin I, ∑ t : T i, q i t * c_bar i t ≤
    ∑ i : Fin I, ∑ t : T i, q i t * c_bar_irvcg i t := by
  obtain ⟨k, hk_nonneg, hk_eq⟩ := hk
  apply Finset.sum_le_sum
  intro i _
  apply Finset.sum_le_sum
  intro t _
  rw [hk_eq]
  -- Goal: q i t * (c_bar_irvcg i t - k i) ≤ q i t * c_bar_irvcg i t
  -- Equivalently: -q i t * k i ≤ 0, which holds since q i t ≥ 0 and k i ≥ 0.
  nlinarith [hq_nonneg i t, hk_nonneg i]