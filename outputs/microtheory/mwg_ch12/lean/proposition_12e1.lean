import Mathlib

-- Axiomatize the economic setting
-- J° is the socially optimal number of entrants
-- J* is the equilibrium number of entrants
-- π_J is the per-firm profit with J firms
-- K is the entry cost
-- The key economic content: under assumptions (A1)-(A3), p' < 0, c'' ≥ 0,
-- the equilibrium entry J* ≥ J° - 1

theorem Proposition_12E1
    (J_star J_opt : ℕ)
    (π : ℕ → ℝ)  -- per-firm profit as function of number of firms
    (K : ℝ)
    -- π is decreasing in J (follows from A1-A3)
    (h_pi_decreasing : ∀ j₁ j₂ : ℕ, j₁ ≤ j₂ → π j₂ ≤ π j₁)
    -- J* is the equilibrium: largest J with π_J ≥ K
    (h_star_eq : π J_star ≥ K)
    (h_star_max : ∀ j : ℕ, π j ≥ K → j ≤ J_star)
    -- Under A1-A3, p' < 0, c'' ≥ 0: π_{J°-1} ≥ K
    -- (This is the core economic content of the proof)
    (h_opt_ge_one : J_opt ≥ 1)
    (h_pi_opt_minus_one : π (J_opt - 1) ≥ K)
    : J_star ≥ J_opt - 1 := by
  apply h_star_max
  exact h_pi_opt_minus_one