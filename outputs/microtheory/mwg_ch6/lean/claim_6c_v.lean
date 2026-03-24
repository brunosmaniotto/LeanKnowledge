import Mathlib

-- Claim 6C_v: Relationship between relative risk aversion and the
-- proportion of wealth invested in the risky asset.
--
-- We axiomatize the economic setting: a utility function u, optimal
-- risky investment α(w), and relative risk aversion r_R(x).
-- Proposition 6.C.2 gives us comparative statics on α(w).
-- The claim concerns y(w) = α(w)/w.

noncomputable section

-- Economic primitives
variable (α : ℝ → ℝ)  -- optimal risky asset investment as function of wealth
variable (w : ℝ)

-- Monotonicity predicates
def IsIncreasingOn (f : ℝ → ℝ) (S : Set ℝ) : Prop :=
  ∀ x y, x ∈ S → y ∈ S → x < y → f x ≤ f y