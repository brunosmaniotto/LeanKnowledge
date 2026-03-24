import Mathlib

inductive NicheChoice | large | small
  deriving DecidableEq

-- Payoffs for Firm E in the Niche Choice game (MWG Figure 9.D.3)
-- Out gives payoff 2. Post-entry payoffs:
noncomputable def payoff_E_out : ℚ := 2

noncomputable def payoff_E_in (e i : NicheChoice) : ℚ :=
  match e, i with
  | NicheChoice.large, NicheChoice.small => 4
  | NicheChoice.small, NicheChoice.large => 1
  | NicheChoice.large, NicheChoice.large => 0
  | NicheChoice.small, NicheChoice.small => 0

-- Payoff for firm I
noncomputable def payoff_I (e i : NicheChoice) : ℚ :=
  match e, i with
  | NicheChoice.large, NicheChoice.small => 3
  | NicheChoice.small, NicheChoice.large => 4
  | NicheChoice.large, NicheChoice.large => 0
  | NicheChoice.small, NicheChoice.small => 0

-- (In, SmallNiche) is strictly dominated by Out for firm E
lemma small_niche_dominated_by_out :
    ∀ i : NicheChoice, payoff_E_in NicheChoice.small i < payoff_E_out := by
  intro i
  cases i <;> simp [payoff_E_in, payoff_E_out] <;> norm_num

-- If E enters and is rational (won't play dominated strategy), E plays LargeNiche