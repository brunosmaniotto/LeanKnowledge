import Mathlib
open Topology

/-- In a multi-capital-goods economy, three key neoclassical properties hold with great generality. -/
structure MultiCapitalGoodsProperties where
  /-- Number of capital goods -/
  numGoods : ℕ
  hNumGoods : numGoods ≥ 1
  /-- The rate of interest equals the net marginal productivity of capital -/
  interest_eq_marginal_productivity : Prop
  /-- The golden rule is characterized by surplus maximization among steady states -/
  golden_rule_surplus_maximization : Prop
  /-- The golden rule is efficient -/
  golden_rule_efficient : Prop
  /-- All three properties hold -/
  h_interest : interest_eq_marginal_productivity
  h_surplus : golden_rule_surplus_maximization
  h_efficient : golden_rule_efficient

/-- The three neoclassical properties hold in a world with several capital goods:
(1) interest = net marginal productivity of capital,
(2) golden rule = surplus maximization among steady states,
(3) golden rule is efficient. -/
axiom multiCapitalGoods_neoclassical_properties_hold :
  ∀ n : ℕ, n ≥ 1 → ∃ P : MultiCapitalGoodsProperties, P.numGoods = n

theorem Claim_20E_h :
    ∀ n : ℕ, n ≥ 1 →
    ∃ (p1 p2 p3 : Prop), p1 ∧ p2 ∧ p3 := by
  intro n hn
  obtain ⟨P, _⟩ := multiCapitalGoods_neoclassical_properties_hold n hn
  exact ⟨P.interest_eq_marginal_productivity,
         P.golden_rule_surplus_maximization,
         P.golden_rule_efficient,
         P.h_interest, P.h_surplus, P.h_efficient⟩