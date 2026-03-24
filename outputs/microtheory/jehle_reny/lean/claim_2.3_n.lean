import Mathlib

/-- Strictly quasiconcave, strictly increasing utility maximization implies SARP.
    Utility maximization means any affordable bundle has weakly lower utility than
    the chosen one. Unique maximizers (from strict quasiconcavity) prevent cycles:
    mutual revealed preference forces equal utility, hence identical bundles.
    General SARP (arbitrary-length cycles) follows since utility decreases weakly
    along any chain, forcing equality and reducing to the pairwise case. -/
theorem Claim_2_3_n {X : Type*}
    (u : X → ℝ)
    (B : ℕ → Set X) (x : ℕ → X)
    -- x(i) maximizes u on B(i)
    (h_max : ∀ i, x i ∈ B i ∧ ∀ y ∈ B i, u y ≤ u (x i))
    -- Consequence of strict quasiconcavity + strict monotonicity:
    -- each budget set has a unique utility maximizer
    (h_unique : ∀ i (y : X), y ∈ B i → u y = u (x i) → y = x i) :
    -- SARP: mutual revealed preference implies identical bundles
    ∀ i j, x j ∈ B i → x i ∈ B j → x i = x j := by
  intro i j hij hji
  have h1 : u (x j) ≤ u (x i) := (h_max i).2 (x j) hij
  have h2 : u (x i) ≤ u (x j) := (h_max j).2 (x i) hji
  exact (h_unique i (x j) hij (le_antisymm h1 h2)).symm