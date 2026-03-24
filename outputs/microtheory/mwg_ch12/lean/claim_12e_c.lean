import Mathlib
open Topology

-- Proposition 12.E.1 (paraphrased): If there is "too little" entry (n_e < n_o),
-- the number of socially optimal firms can exceed the number of equilibrium firms
-- by at most one.
theorem Claim_12E_c
  -- Model parameters
  (π : ℕ → ℝ) -- π n is the profit of a single firm when n firms are in the market.
  (S : ℕ → ℝ) -- S n is the gross social surplus (consumer + producer) with n firms.
  (K : ℝ)     -- K is the fixed cost of entry for each firm.
  -- Key model assumption: the "business-stealing" effect in homogeneous-good markets.
  -- The marginal increase in social surplus from the n-th firm is less than the
  -- per-firm profit in the (n-1)-firm market. We assume this for n > 1.
  (h_key_ineq : ∀ n > 1, S n - S (n - 1) < π (n - 1))
  -- Equilibrium and optimal number of firms
  (n_e n_o : ℕ)
  -- Definition of n_e (equilibrium number of firms): the (n_e + 1)-th firm is unprofitable.
  (hne_profit : π (n_e + 1) < K)
  -- Definition of n_o (socially optimal number of firms): entry is socially desirable for all firms up to n_o.
  (hno_profit : ∀ n, n > 0 → n ≤ n_o → S n - S (n - 1) ≥ K)
  : n_o ≤ n_e + 1 := by
  -- Proof by contradiction. Assume the social optimum has at least 2 more firms
  -- than the equilibrium, i.e., n_o ≥ n_e + 2.
  by_contra h_contra
  -- Convert the negated goal into a more direct hypothesis.
  push_neg at h_contra
  have h_at_least_two_more : n_e + 2 ≤ n_o := by linarith

  -- By definition of n_o, entry is socially desirable for firm n_e + 2,
  -- since n_e + 2 ≤ n_o.
  have h_marginal_surplus_ge_K : S (n_e + 2) - S (n_e + 1) ≥ K :=
    -- To apply hno_profit, we need n > 0 and n ≤ n_o.
    -- n_e + 2 > 0 is true because n_e is a natural number (n_e ≥ 0).
    -- n_e + 2 ≤ n_o is our assumption h_at_least_two_more.
    hno_profit (n_e + 2) (by linarith) h_at_least_two_more

  -- Now, use the key business-stealing inequality for homogeneous-good models.
  -- This applies because n_e + 2 > 1.
  have h_surplus_lt_profit : S (n_e + 2) - S (n_e + 1) < π (n_e + 1) :=
    h_key_ineq (n_e + 2) (by linarith)

  -- Combining these facts gives K < π(n_e + 1).
  have h_K_lt_pi : K < π (n_e + 1) :=
    calc
      K ≤ S (n_e + 2) - S (n_e + 1) := h_marginal_surplus_ge_K
      _ < π (n_e + 1)             := h_surplus_lt_profit

  -- But this contradicts our definition of n_e (hne_profit), which states that
  -- profit for the (n_e + 1)-th firm is *less* than the entry cost K.
  linarith [hne_profit, h_K_lt_pi]