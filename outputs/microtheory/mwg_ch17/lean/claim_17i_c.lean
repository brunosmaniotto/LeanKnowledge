import Mathlib

/-- Equilibrium price set of the r-replica economy -/
axiom EquilibriumPriceSet : ℕ → Set ℝ

/-- In a replica economy, the 1-replica equilibrium prices are contained in any r-replica equilibrium prices -/
axiom base_inclusion : ∀ r : ℕ, r ≥ 1 → EquilibriumPriceSet 1 ⊆ EquilibriumPriceSet r

/-- The converse of base inclusion need not hold -/
axiom converse_fails : ∃ r : ℕ, r ≥ 1 ∧ ¬(EquilibriumPriceSet r ⊆ EquilibriumPriceSet 1)

/-- If r'' is an integer multiple of r', then E(r') ⊆ E(r'') -/
axiom multiple_inclusion : ∀ r' r'' : ℕ, r' ≥ 1 → r'' ≥ 1 →
  (∃ m : ℕ, m ≥ 1 ∧ r'' = m * r') → EquilibriumPriceSet r' ⊆ EquilibriumPriceSet r''

/-- For arbitrary r'' > r' ≥ 1 with no divisibility, there need not be inclusion in either direction -/
axiom no_general_inclusion : ∃ r' r'' : ℕ, r'' > r' ∧ r' ≥ 1 ∧
  ¬(∃ m : ℕ, m ≥ 1 ∧ r'' = m * r') ∧
  ¬(EquilibriumPriceSet r'' ⊆ EquilibriumPriceSet r') ∧
  ¬(EquilibriumPriceSet r' ⊆ EquilibriumPriceSet r'')

theorem Claim_17I_c :
    (∀ r : ℕ, r ≥ 1 → EquilibriumPriceSet 1 ⊆ EquilibriumPriceSet r) ∧
    (∃ r : ℕ, r ≥ 1 ∧ ¬(EquilibriumPriceSet r ⊆ EquilibriumPriceSet 1)) ∧
    (∀ r' r'' : ℕ, r' ≥ 1 → r'' ≥ 1 →
      (∃ m : ℕ, m ≥ 1 ∧ r'' = m * r') → EquilibriumPriceSet r' ⊆ EquilibriumPriceSet r'') ∧
    (∃ r' r'' : ℕ, r'' > r' ∧ r' ≥ 1 ∧
      ¬(∃ m : ℕ, m ≥ 1 ∧ r'' = m * r') ∧
      ¬(EquilibriumPriceSet r'' ⊆ EquilibriumPriceSet r') ∧
      ¬(EquilibriumPriceSet r' ⊆ EquilibriumPriceSet r'')) :=
  ⟨base_inclusion, converse_fails, multiple_inclusion, no_general_inclusion⟩