import Mathlib
open Topology

/-
A revelation mechanism for the externality problem:
The firm and consumer are each asked to report their values `b_hat` and `c_hat`.

- For announcements (`b_hat`, `c_hat`), the government sets `h = h_bar` if and only if `b_hat ≥ c_hat`.
- If `h = h_bar`, the firm is taxed `c_hat` and the consumer is subsidized `b_hat`.

The outcome when `b_hat < c_hat` (and thus `h ≠ h_bar`) is not explicitly specified in the
original definition. For completeness, we assume `h` takes a default value `h_default`,
and both the firm's tax and consumer's subsidy are zero in this case.

This definition is marked `noncomputable` because it uses `b_hat ≥ c_hat` for real numbers,
which relies on `Real.decidableLE`, a noncomputable instance.
-/
noncomputable def Implicit_Def_11E_b {H : Type} (h_bar h_default : H) (b_hat c_hat : ℝ) : H × ℝ × ℝ :=
  if b_hat ≥ c_hat then
    (h_bar, c_hat, b_hat) -- (h, firm_tax, consumer_subsidy)
  else
    (h_default, 0, 0)     -- (h, firm_tax, consumer_subsidy) when b_hat < c_hat