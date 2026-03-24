import Mathlib

open BigOperators Finset
open Topology

/-- Short-run equilibrium: given J firms, market-clearing alone determines price. -/
structure ShortRunEq (J : ℕ) (qd : ℝ → ℝ) (qs : Fin J → ℝ → ℝ) where
  p : ℝ
  market_clearing : qd p = ∑ j : Fin J, qs j p

/-- Long-run equilibrium: both price and number of firms determined jointly
    by market-clearing and zero-profit conditions. -/
structure LongRunEq (qd : ℝ → ℝ) (qs : ℕ → ℝ → ℝ) (profit : ℕ → ℝ → ℝ) where
  p : ℝ
  J : ℕ
  market_clearing : qd p = ∑ j ∈ range J, qs j p
  zero_profit : ∀ j : ℕ, j < J → profit j p = 0

/-- Claim 4.1.h: In the short run, equilibrium is pinned down by market-clearing
    for a fixed number of firms. In the long run, both price and number of firms
    are determined jointly by market-clearing and zero-profit conditions.

    We formalize this by showing:
    (1) Given fixed J and supply/demand that cross, a short-run equilibrium exists
        (one equation in one unknown p).
    (2) Given supply/demand/profit functions satisfying both conditions at some
        (p, J), a long-run equilibrium exists (two equations in two unknowns). -/
theorem claim_4_1_h :
    -- (1) Short-run: given J, if market-clearing holds at some price, equilibrium exists
    (∀ (J : ℕ) (qd : ℝ → ℝ) (qs : Fin J → ℝ → ℝ) (p : ℝ),
      qd p = ∑ j : Fin J, qs j p →
      Nonempty (ShortRunEq J qd qs)) ∧
    -- (2) Long-run: if both conditions hold at some (p, J), equilibrium exists
    (∀ (qd : ℝ → ℝ) (qs : ℕ → ℝ → ℝ) (profit : ℕ → ℝ → ℝ) (p : ℝ) (J : ℕ),
      qd p = ∑ j ∈ range J, qs j p →
      (∀ j, j < J → profit j p = 0) →
      Nonempty (LongRunEq qd qs profit)) := by
  constructor
  · intro J qd qs p hmc
    exact ⟨⟨p, hmc⟩⟩
  · intro qd qs profit p J hmc hzp
    exact ⟨⟨p, J, hmc, hzp⟩⟩