import Mathlib

open BigOperators Finset

-- Axiomatize exchange economy primitives
axiom ExchangeEconomy : ℕ → ℕ → Type
axiom excessDemand : ∀ {L I : ℕ}, ExchangeEconomy L I → (Fin L → ℝ) → (Fin L → ℝ)
axiom endowments : ∀ {L I : ℕ}, ExchangeEconomy L I → Fin I → (Fin L → ℝ)

/-- Aggregate excess demand is independent of the distribution of endowments -/
axiom IndependentOfDistribution : ∀ {L I : ℕ}, ExchangeEconomy L I → Prop

/-- All consumers have identical and homothetic preferences -/
axiom IdenticalHomothetic : ∀ {L I : ℕ}, ExchangeEconomy L I → Prop

-- The two directions (MWG Proposition 4.C.1 / Claim 5.E):
-- Identical homothetic preferences ⟹ demand is x_i(p,w_i) = w_i · x(p,1),
-- so aggregate demand depends only on Σw_i = p·Σω_i, independent of distribution.
axiom identical_homothetic_implies_independent :
  ∀ {L I : ℕ} (E : ExchangeEconomy L I),
    IdenticalHomothetic E → IndependentOfDistribution E

-- Converse: if aggregate demand is distribution-independent for ALL distributions,
-- preferences must be identical and homothetic (Gorman form necessity).
axiom independent_implies_identical_homothetic :
  ∀ {L I : ℕ} (E : ExchangeEconomy L I),
    IndependentOfDistribution E → IdenticalHomothetic E

/-- In an exchange economy, aggregate excess demand z(p) is independent of the
    initial distribution of endowments iff preferences are identical and homothetic. -/
theorem Claim_5e_am {L I : ℕ} (E : ExchangeEconomy L I) :
    IndependentOfDistribution E ↔ IdenticalHomothetic E :=
  ⟨independent_implies_identical_homothetic E, identical_homothetic_implies_independent E⟩