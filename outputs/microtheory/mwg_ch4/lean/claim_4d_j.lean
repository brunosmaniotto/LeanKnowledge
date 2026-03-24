import Mathlib

-- Welfare significance requires not just that preferences explain aggregate behavior,
-- but that wealth distribution arises from social welfare optimization.
theorem claim_4D_j
    (PreferencesExist : Prop)
    (WealthFromSWO : Prop)
    (WelfareSignificance : Prop)
    (h_welfare_iff : WelfareSignificance ↔ PreferencesExist ∧ WealthFromSWO)
    (h_prefs : PreferencesExist)
    (h_no_swo : ¬WealthFromSWO) :
    PreferencesExist ∧ ¬WelfareSignificance := by
  exact ⟨h_prefs, fun hw => h_no_swo (h_welfare_iff.mp hw).2⟩