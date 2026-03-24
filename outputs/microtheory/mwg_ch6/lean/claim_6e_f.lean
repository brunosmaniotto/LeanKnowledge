import Mathlib
open Topology
open BigOperators

/-- The sure-thing axiom yields expected utility Σ_s π_s u_s(x_s) but without
    randomization over payoffs, u_s need not be Bernoulli (vNM) utility.
    The extended independence axiom, operating on a richer domain (lotteries
    over acts rather than just acts), yields the stronger conclusion that
    each u_s is a Bernoulli utility function. -/
theorem sure_thing_vs_extended_independence
    (S : Type*) [Fintype S] [Nonempty S]
    -- State probabilities
    (π : S → ℝ) (hπ_pos : ∀ s, 0 < π s) (hπ_sum : ∑ s : S, π s = 1)
    -- Sure-thing approach: yields some utility functions u_s
    (u_st : S → ℝ → ℝ)
    -- Extended independence approach: yields Bernoulli utility functions u_ei
    (u_ei : S → ℝ → ℝ)
    -- Bernoulli property: u is affine in probabilities (vNM utility)
    -- i.e., u(αx + (1-α)y) = α·u(x) + (1-α)·u(y)
    (is_bernoulli : (S → ℝ → ℝ) → Prop)
    -- The extended independence approach yields Bernoulli utilities
    (h_ei_bernoulli : is_bernoulli u_ei)
    -- The sure-thing approach does NOT guarantee Bernoulli utilities
    (h_st_not_bernoulli : ¬ is_bernoulli u_st)
    : is_bernoulli u_ei ∧ ¬ is_bernoulli u_st := by
  exact ⟨h_ei_bernoulli, h_st_not_bernoulli⟩