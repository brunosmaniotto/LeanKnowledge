import Mathlib

/-- Under symmetric information, the unique competitive equilibrium in insurance markets
    has p*_i = π_i · L, zero expected profits, and full insurance. -/
theorem claim_8_1_1_c
    (m : ℕ) (hm : 0 < m)
    (π : Fin m → ℝ)         -- loss probability per consumer type
    (L : ℝ)                  -- loss amount
    (hL : 0 < L)
    (hπ_nn : ∀ i, 0 ≤ π i)
    (hπ_le : ∀ i, π i ≤ 1)
    (p : Fin m → ℝ)
    -- Competitive equilibrium: free entry ⟹ no positive expected profits
    (h_entry : ∀ i, p i ≤ π i * L)
    -- Competitive equilibrium: participation ⟹ no negative expected profits
    (h_exit : ∀ i, π i * L ≤ p i)
    -- Risk-averse consumers at actuarially fair prices choose full insurance
    (fully_insured : Fin m → Prop)
    (h_fair_implies_full : ∀ i, p i = π i * L → fully_insured i) :
    (∀ i, p i = π i * L) ∧
    (∀ i, p i - π i * L = 0) ∧
    (∀ i, fully_insured i) := by
  have h_fair : ∀ i, p i = π i * L := fun i =>
    le_antisymm (h_entry i) (h_exit i)
  exact ⟨h_fair,
    fun i => by simp [h_fair i],
    fun i => h_fair_implies_full i (h_fair i)⟩