import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/--
Nash bargaining characterization: if ū maximizes the weighted sum
∑ᵢ (1/ūᵢ)·uᵢ over U (utilitarian with weights ηᵢ = γ/ūᵢ from the
egalitarian condition), then ū maximizes ∑ᵢ ln(uᵢ) over U.
Applies ln(x) ≤ x − 1 to each ratio uᵢ/ūᵢ.
-/
theorem nash_from_utilitarian_egalitarian
    {n : ℕ}
    (u_bar : Fin n → ℝ)
    (hu_bar_pos : ∀ i, 0 < u_bar i)
    (U : Set (Fin n → ℝ))
    (hU_pos : ∀ u ∈ U, ∀ i, 0 < u i)
    (h_util : ∀ u ∈ U,
      ∑ i ∈ Finset.univ, (u i / u_bar i) ≤
      ∑ i ∈ Finset.univ, (u_bar i / u_bar i)) :
    ∀ u ∈ U,
      ∑ i ∈ Finset.univ, Real.log (u i) ≤
      ∑ i ∈ Finset.univ, Real.log (u_bar i) := by
  intro u hu
  -- ln(uᵢ/ūᵢ) ≤ uᵢ/ūᵢ - 1 for each i, by concavity of ln
  have hln : ∀ i : Fin n,
      Real.log (u i) - Real.log (u_bar i) ≤ u i / u_bar i - 1 := by
    intro i
    have := Real.log_le_sub_one_of_pos (div_pos (hU_pos u hu i) (hu_bar_pos i))
    rwa [Real.log_div (ne_of_gt (hU_pos u hu i)) (ne_of_gt (hu_bar_pos i))] at this
  -- Sum: ∑ (ln uᵢ - ln ūᵢ) ≤ ∑ (uᵢ/ūᵢ - 1)
  have hsum : ∑ i ∈ univ, (Real.log (u i) - Real.log (u_bar i)) ≤
      ∑ i ∈ univ, (u i / u_bar i - 1) :=
    Finset.sum_le_sum fun i _ => hln i
  -- Rewrite both sums using sum_sub_distrib
  rw [Finset.sum_sub_distrib] at hsum
  rw [Finset.sum_sub_distrib] at hsum
  -- From utilitarian condition: ∑ uᵢ/ūᵢ ≤ ∑ ūᵢ/ūᵢ = ∑ 1 = n
  have hutil := h_util u hu
  simp_rw [div_self (ne_of_gt (hu_bar_pos _))] at hutil
  linarith