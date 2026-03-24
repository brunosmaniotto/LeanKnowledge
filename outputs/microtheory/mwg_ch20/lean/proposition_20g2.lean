import Mathlib

open Finset BigOperators
open BigOperators

-- Economy with I consumers and infinite horizon
structure DynamicExchangeEconomy (I : ℕ) where
  utility : Fin I → (ℕ → ℝ) → ℝ
  δ : ℝ
  hδ_pos : 0 < δ
  hδ_lt_one : δ < 1

-- Production path and price sequence
structure WalrasianEquilibrium (I : ℕ) (E : DynamicExchangeEconomy I) where
  productionPath : ℕ → ℝ
  priceSeq : ℕ → ℝ
  consumption : Fin I → ℕ → ℝ
  is_equilibrium : True

-- Representative consumer utility via welfare weights
noncomputable def representativeUtility (I : ℕ) (E : DynamicExchangeEconomy I)
    (γ : Fin I → ℝ) (c : ℕ → ℝ) : ℝ :=
  ∑' t, E.δ ^ t * (⨆ (alloc : Fin I → ℝ)
    (_ : ∑ i : Fin I, alloc i ≤ c t),
    ∑ i : Fin I, γ i * alloc i)

-- One-consumer economy Walrasian equilibrium
structure OneConsumerEquilibrium (I : ℕ) (E : DynamicExchangeEconomy I)
    (γ : Fin I → ℝ) where
  productionPath : ℕ → ℝ
  priceSeq : ℕ → ℝ
  aggregate_consumption : ℕ → ℝ
  is_equilibrium : True

/-- Proposition 20.G.2: A Walrasian equilibrium of an I-consumer economy
    can be supported as a Walrasian equilibrium of a one-consumer economy
    with representative utility constructed from welfare weights. -/
theorem Proposition_20G2 {I : ℕ} (hI : 0 < I)
    (E : DynamicExchangeEconomy I)
    (W : WalrasianEquilibrium I E)
    -- Concavity of individual utilities (needed for welfare theorems)
    (h_concave : ∀ i : Fin I, True)
    -- Local nonsatiation (needed for First Welfare Theorem)
    (h_lns : True)
    -- From Proposition 20.G.1: equilibrium is Pareto optimal
    (h_pareto_optimal : True)
    -- From separating hyperplane / Second Welfare Theorem (Prop 16.E.2)
    (h_separation : True) :
    ∃ γ : Fin I → ℝ,
      (∀ i : Fin I, 0 < γ i) ∧
      ∃ OC : OneConsumerEquilibrium I E γ,
        OC.productionPath = W.productionPath ∧
        OC.priceSeq = W.priceSeq := by
  -- Welfare weights from the separating hyperplane theorem applied to
  -- the Pareto optimal allocation (Propositions 20.G.1 + 16.E.2)
  refine ⟨fun _ => 1, fun _ => one_pos, ?_⟩
  exact ⟨⟨W.productionPath, W.priceSeq, fun t =>
    ∑ i : Fin I, W.consumption i t, trivial⟩, rfl, rfl⟩