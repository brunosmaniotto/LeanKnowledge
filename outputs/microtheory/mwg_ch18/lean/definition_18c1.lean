import Mathlib
open BigOperators

/-- A trading equilibrium in a market with I agents.
  Each agent i has a set of market actions, an endowment vector, and a utility function.
  A trading rule assigns net trade vectors satisfying budget balance,
  and a market clearing process generates price vectors.
  The equilibrium condition requires that no agent can improve their utility
  by unilaterally changing their action. -/
structure TradingEquilibrium
    (I : Type*) [Fintype I] [DecidableEq I]
    (L : ℕ)
    (A : I → Type*)
    (P : Type*)
    (ω : I → Fin L → ℝ)
    (g : (i : I) → A i → (Fin L → ℝ) → Fin L → ℝ)
    (priceProcess : ((i : I) → A i) → P)
    (priceVec : P → Fin L → ℝ)
    (u : (i : I) → (Fin L → ℝ) → ℝ) where
  /-- The equilibrium action profile -/
  actionProfile : (i : I) → A i
  /-- Budget balance: for every agent and price, the value of the net trade is zero -/
  budget_balance : ∀ (i : I) (aᵢ : A i) (p : Fin L → ℝ),
    ∑ l : Fin L, p l * g i aᵢ p l = 0
  /-- Equilibrium condition: no agent can improve utility by unilateral deviation.
      When agent i deviates to aᵢ, the price adjusts via the market clearing process
      applied to the modified action profile. -/
  equilibrium : ∀ (i : I) (aᵢ : A i),
    u i (fun l => g i (actionProfile i) (priceVec (priceProcess actionProfile)) l + ω i l) ≥
    u i (fun l => g i aᵢ (priceVec (priceProcess (Function.update actionProfile i aᵢ))) l + ω i l)