import Mathlib

open BigOperators Finset
open Topology

/-- A **competitive (price-taking) firm** in an economy with `L` goods.

The firm takes market prices as given on both output and input markets:
it believes its production decisions have no effect on prevailing prices.
Prices enter as exogenous parameters (a fixed vector), not as functions
of the firm's chosen production plan.

Uses the MWG net-output convention: in a production plan `y : Fin L → ℝ`,
positive components are outputs and negative components are inputs. -/
structure CompetitiveFirm (L : ℕ) where
  /-- Market prices, taken as given (exogenous to the firm) -/
  price : Fin L → ℝ
  /-- The firm's production set (feasible net-output vectors) -/
  Y : Set (Fin L → ℝ)
  /-- The production set is nonempty -/
  Y_nonempty : Y.Nonempty

/-- The profit of a competitive firm at production plan `y`: the inner
    product `p · y = ∑_l p_l · y_l`. Because the firm is a price taker,
    `price` is constant regardless of `y`. -/
noncomputable def M.Profit {L : ℕ} (f : CompetitiveFirm L)
    (y : Fin L → ℝ) : ℝ :=
  ∑ l : Fin L, f.price l * y l