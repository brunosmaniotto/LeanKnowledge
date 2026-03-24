import Mathlib
open Filter Topology BigOperators
open Topology
open BigOperators

/-- Consistency formalizes the common beliefs principle: each joint mixed strategy
    in the convergent sequence represents a common belief shared by all players
    about how the joint pure strategy is chosen. The limit assessment inherits
    this common belief property because Bayes-derived beliefs converge to the
    Bayes beliefs of the limit strategy. -/
theorem consistency_common_beliefs_principle
    {n : ℕ}
    (σ_seq : ℕ → Fin n → ℝ)
    (σ_lim : Fin n → ℝ)
    (h_conv : ∀ i, Tendsto (fun k => σ_seq k i) atTop (nhds (σ_lim i)))
    (μ_seq : ℕ → Fin n → ℝ)
    (h_bayes : ∀ k i, μ_seq k i = σ_seq k i / ∑ j : Fin n, σ_seq k j)
    (h_sum_lim_pos : 0 < ∑ j : Fin n, σ_lim j)
    : ∀ i, Tendsto (fun k => μ_seq k i) atTop
        (nhds (σ_lim i / ∑ j : Fin n, σ_lim j)) := by
  intro i
  simp_rw [h_bayes]
  exact Tendsto.div (h_conv i)
    (tendsto_finset_sum Finset.univ (fun j _ => h_conv j))
    h_sum_lim_pos.ne'