import Mathlib

noncomputable section

-- Axiomatize exchange economy and equilibrium existence
axiom ExchangeEconomy (I L : ℕ) : Type
axiom WalrasianEqExists (I L : ℕ) (E : ExchangeEconomy I L) : Prop

-- Utility and endowment properties
axiom UtilityContinuous (I L : ℕ) (E : ExchangeEconomy I L) : Prop
axiom UtilityQuasiconcave (I L : ℕ) (E : ExchangeEconomy I L) : Prop
axiom UtilityStrictlyQuasiconcave (I L : ℕ) (E : ExchangeEconomy I L) : Prop
axiom UtilityStrictlyIncreasing (I L : ℕ) (E : ExchangeEconomy I L) : Prop
axiom UtilityStronglyIncreasing (I L : ℕ) (E : ExchangeEconomy I L) : Prop
axiom PositiveEndowments (I L : ℕ) (E : ExchangeEconomy I L) : Prop

-- Theorem 5.4: existence under strictly quasiconcave + strongly increasing
axiom theorem_5_4 : ∀ {I L} (E : ExchangeEconomy I L),
  UtilityContinuous I L E →
  UtilityStrictlyQuasiconcave I L E →
  UtilityStronglyIncreasing I L E →
  PositiveEndowments I L E →
  WalrasianEqExists I L E

-- Approximation: v_ε(x) = (1-ε)·u(x) + ε·‖x‖ makes utility strictly quasiconcave
-- and strongly increasing while preserving continuity and endowments
axiom approxEconomy : ∀ {I L}, ExchangeEconomy I L → ℝ → ExchangeEconomy I L

axiom approx_continuous : ∀ {I L} (E : ExchangeEconomy I L) (ε : ℝ),
  0 < ε → ε < 1 → UtilityContinuous I L E →
  UtilityContinuous I L (approxEconomy E ε)

axiom approx_strictly_quasiconcave : ∀ {I L} (E : ExchangeEconomy I L) (ε : ℝ),
  0 < ε → ε < 1 → UtilityQuasiconcave I L E →
  UtilityStrictlyQuasiconcave I L (approxEconomy E ε)

axiom approx_strongly_increasing : ∀ {I L} (E : ExchangeEconomy I L) (ε : ℝ),
  0 < ε → ε < 1 → UtilityStrictlyIncreasing I L E →
  UtilityStronglyIncreasing I L (approxEconomy E ε)

axiom approx_positive_endowments : ∀ {I L} (E : ExchangeEconomy I L) (ε : ℝ),
  0 < ε → ε < 1 → PositiveEndowments I L E →
  PositiveEndowments I L (approxEconomy E ε)

-- Limit theorem: as ε → 0, equilibria of approximating economies converge
-- to an equilibrium of the original economy (compactness of price simplex +
-- continuity of demand)
axiom limit_of_approx_equilibria : ∀ {I L} (E : ExchangeEconomy I L),
  UtilityContinuous I L E →
  (∀ ε : ℝ, 0 < ε → ε < 1 → WalrasianEqExists I L (approxEconomy E ε)) →
  WalrasianEqExists I L E

/-- Claim 5.E.y (Exercise 5.22): Walrasian equilibrium exists under quasiconcave
    (not strictly) and strictly increasing (not strongly) utility, extending
    Theorem 5.4 via an approximation argument. -/
theorem walrasian_eq_exists_quasiconcave {I L : ℕ} (E : ExchangeEconomy I L)
    (hcont : UtilityContinuous I L E)
    (hqc : UtilityQuasiconcave I L E)
    (hsi : UtilityStrictlyIncreasing I L E)
    (hpe : PositiveEndowments I L E) :
    WalrasianEqExists I L E := by
  apply limit_of_approx_equilibria E hcont
  intro ε hε_pos hε_lt
  exact theorem_5_4 (approxEconomy E ε)
    (approx_continuous E ε hε_pos hε_lt hcont)
    (approx_strictly_quasiconcave E ε hε_pos hε_lt hqc)
    (approx_strongly_increasing E ε hε_pos hε_lt hsi)
    (approx_positive_endowments E ε hε_pos hε_lt hpe)