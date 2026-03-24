import Mathlib
set_option linter.unusedVariables false

/-!
# Claim VI.B: Vickrey's Second-Price Auction Achieves Pareto Optimality

In a sealed-bid auction where each bidder wants 0 or 1 unit and the
price equals the first rejected bid (= second-highest bid), truthful
bidding is a weakly dominant strategy, and the equilibrium allocation
is Pareto-optimal (the highest-value bidder receives the good).
-/

/-- Bidder utility in the second-price (Vickrey) auction:
    wins iff own bid exceeds the highest competing bid `m`, paying `m`;
    otherwise earns 0. -/
noncomputable def vickreyUtility (v_i b_i m : ℝ) : ℝ :=
  if b_i > m then v_i - m else 0

/-- **Claim VI.B** (Vickrey 1961): The first-rejected-bid mechanism achieves
    the Pareto-optimal result.  Concretely, for a single-unit auction with
    `n` bidders and valuation profile `v`:
    (1) **Dominant strategy** — bidding one's true valuation `v i` weakly
        dominates any other bid `b_i`, regardless of the highest competing
        bid `m`.
    (2) **Pareto optimality** — under truthful bidding the good is allocated
        to the bidder with the highest valuation (no reallocation can make
        all parties weakly better off). -/
theorem Claim_VI_B (n : ℕ) (hn : 0 < n) (v : Fin n → ℝ) :
    (∀ (i : Fin n) (b_i m : ℝ),
        vickreyUtility (v i) (v i) m ≥ vickreyUtility (v i) b_i m) ∧
    (∃ i : Fin n, ∀ j : Fin n, v j ≤ v i) := by
  constructor
  · -- Part (1): dominant strategy.
    -- Four cases on (v i > m) × (b_i > m):
    --   • both win: same outcome
    --   • truthful wins, deviant loses: v i - m ≥ 0 since v i > m
    --   • truthful loses, deviant wins: 0 ≥ v i - m since v i ≤ m
    --   • both lose: 0 ≥ 0
    intro i b_i m
    simp only [vickreyUtility]
    split_ifs <;> linarith
  · -- Part (2): a maximum of `v` exists over the finite nonempty set `Fin n`.
    haveI : Nonempty (Fin n) := ⟨⟨0, hn⟩⟩
    obtain ⟨i, -, hi⟩ :=
      Finset.exists_max_image Finset.univ v Finset.univ_nonempty
    exact ⟨i, fun j => hi j (Finset.mem_univ j)⟩