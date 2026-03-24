import Mathlib

open Set
open Real

theorem neg_inf_eq_sup_neg {T : Set ℝ} (hT : T.Nonempty) (h_bdd : BddBelow T) :
    BddAbove (-T) ∧ - (sInf T) = sSup (-T) := by
  -- Show -T is nonempty because T is
  have h_neg_nonempty : (-T).Nonempty := by
    rcases hT with ⟨t, ht⟩
    exact ⟨-t, by simp [ht]⟩
  -- -sInf T is an upper bound for -T
  have h_upper_bound : ∀ y ∈ -T, y ≤ - (sInf T) := by
    intro y hy
    have : -y ∈ T := hy
    have h_inf_le : sInf T ≤ -y := csInf_le h_bdd this
    linarith
  have h_bdd_above : BddAbove (-T) := ⟨- (sInf T), h_upper_bound⟩
  -- Prove equality via antisymmetry
  have h_sup_le : sSup (-T) ≤ - (sInf T) := by
    apply csSup_le h_neg_nonempty h_upper_bound
  have h_inf_le : - (sInf T) ≤ sSup (-T) := by
    -- Show -sSup(-T) is a lower bound for T
    have h_lower_bound : ∀ t ∈ T, - (sSup (-T)) ≤ t := by
      intro t ht
      have h_neg_t : -t ∈ -T := by simp [ht]
      have h_le : -t ≤ sSup (-T) := le_csSup h_bdd_above h_neg_t
      linarith
    have h_inf_bound : - (sSup (-T)) ≤ sInf T := le_csInf hT h_lower_bound
    linarith
  have h_eq : - (sInf T) = sSup (-T) := by linarith
  exact ⟨h_bdd_above, h_eq⟩