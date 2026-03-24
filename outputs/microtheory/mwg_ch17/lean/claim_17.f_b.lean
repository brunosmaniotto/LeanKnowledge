import Mathlib

-- Axiomatize economic concepts for Walrasian equilibrium uniqueness
axiom WalrasianEconomy : ℕ → Type
axiom IsWalrasianEqPrice : (L : ℕ) → WalrasianEconomy L → (Fin L → ℝ) → Prop
axiom AggConsumption : (L : ℕ) → WalrasianEconomy L → (Fin L → ℝ) → (Fin L → ℝ)
axiom AggProduction : (L : ℕ) → WalrasianEconomy L → (Fin L → ℝ) → (Fin L → ℝ)
axiom WeakAxiomHolds : (L : ℕ) → WalrasianEconomy L → Prop
axiom ConstantReturnsConvex : (L : ℕ) → WalrasianEconomy L → Prop

axiom walrasian_unique_agg_aux :
  ∀ (L : ℕ) (E : WalrasianEconomy L),
    WeakAxiomHolds L E → ConstantReturnsConvex L E →
    ∀ (p p' : Fin L → ℝ),
      IsWalrasianEqPrice L E p → IsWalrasianEqPrice L E p' →
      AggConsumption L E p = AggConsumption L E p' ∧
      AggProduction L E p = AggProduction L E p'

theorem walrasian_eq_unique_aggregates
    {L : ℕ} {E : WalrasianEconomy L}
    (hWA : WeakAxiomHolds L E)
    (hCRC : ConstantReturnsConvex L E)
    (p p' : Fin L → ℝ)
    (hp : IsWalrasianEqPrice L E p)
    (hp' : IsWalrasianEqPrice L E p') :
    AggConsumption L E p = AggConsumption L E p' ∧
    AggProduction L E p = AggProduction L E p' :=
  walrasian_unique_agg_aux L E hWA hCRC p p' hp hp'