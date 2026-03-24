import Mathlib

/-- Monotonicity axiom (MWG Axiom G4): Among best-worst lotteries,
    higher probability of the best outcome is weakly preferred.
    `pref` is the weak preference relation on lotteries,
    `bwLottery` maps a probability α ∈ [0,1] to the lottery
    (α ∘ a₁, (1-α) ∘ aₙ). -/
def MonotonicityAxiom {L : Type*} (pref : L → L → Prop)
    (bwLottery : Set.Icc (0 : ℝ) 1 → L) : Prop :=
  ∀ α β : Set.Icc (0 : ℝ) 1,
    pref (bwLottery α) (bwLottery β) ↔ (α : ℝ) ≥ (β : ℝ)