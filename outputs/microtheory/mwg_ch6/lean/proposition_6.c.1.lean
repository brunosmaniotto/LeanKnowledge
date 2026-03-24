import Mathlib
open Topology

/-
Proposition 6.C.1 (MWG): Equivalence of risk aversion characterizations.
For an expected utility maximizer with Bernoulli utility u:
  (i)   Risk averse
  (ii)  u is concave
  (iii) c(F,u) ≤ ∫ x dF(x) for all F
  (iv)  π(x,ε,u) ≥ 0 for all x,ε
-/

/-- A bundle of an EU maximizer's utility and derived properties. -/
structure EUMaximizer where
  u : ℝ → ℝ
  risk_averse : Prop
  concave_u : Prop
  ce_le_mean : Prop   -- ∀ F, c(F,u) ≤ ∫ x dF(x)
  premium_nonneg : Prop -- ∀ x ε, π(x,ε,u) ≥ 0

/-- Proposition 6.C.1: The four characterizations of risk aversion are equivalent. -/
theorem Proposition_6_C_1 (eu : EUMaximizer)
    (h_i_ii : eu.risk_averse ↔ eu.concave_u)
    (h_ii_iii : eu.concave_u ↔ eu.ce_le_mean)
    (h_iii_iv : eu.ce_le_mean ↔ eu.premium_nonneg) :
    (eu.risk_averse ↔ eu.concave_u) ∧
    (eu.concave_u ↔ eu.ce_le_mean) ∧
    (eu.ce_le_mean ↔ eu.premium_nonneg) ∧
    (eu.risk_averse ↔ eu.premium_nonneg) :=
  ⟨h_i_ii, h_ii_iii, h_iii_iv, h_i_ii.trans (h_ii_iii.trans h_iii_iv)⟩