import Mathlib

open Finset BigOperators
open Topology

/-- Risk aversion in state s means the agent prefers the expected value of any
    lottery to the lottery itself. For a Bernoulli utility u, this is equivalent
    to u being concave. -/
theorem Claim_6E_d
    {S : Type*} [Fintype S] [DecidableEq S]
    (u : S → ℝ → ℝ)
    (h_concave : ∀ s, ConcaveOn ℝ Set.univ (u s)) :
    ∀ s, ∀ (p : ℝ) (x y : ℝ), 0 ≤ p → p ≤ 1 →
      u s (p * x + (1 - p) * y) ≥ p * u s x + (1 - p) * u s y := by
  intro s p x y hp hp1
  have hc := h_concave s
  exact hc.2 (Set.mem_univ x) (Set.mem_univ y) (by linarith) (by linarith)
    (by ring)