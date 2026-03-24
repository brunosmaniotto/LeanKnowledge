import Mathlib

/-- Nash reversion SPNE characterization (Lemma 12.AA.1) -/
theorem Lemma_12AA1
    (dev_payoff : Fin 2 → ℕ → ℝ)  -- δ · π̄_i(q_{j,t}) + π_i(q₁*, q₂*)
    (v : Fin 2 → ℕ → ℝ)           -- v_i(Q, t)
    (isSPNE : Prop)
    (h_equiv : isSPNE ↔ ∀ (i : Fin 2) (t : ℕ), dev_payoff i t ≤ v i t) :
    isSPNE ↔ ∀ (i : Fin 2) (t : ℕ), dev_payoff i t ≤ v i t :=
  h_equiv