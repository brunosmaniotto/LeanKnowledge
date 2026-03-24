import Mathlib

/-- The income effect (Hicksian decomposition): the residual of the total price effect
    after removing the substitution effect. For good `l` when price `k` changes,
    IE_{lk} = total_effect_{lk} - substitution_effect_{lk}.
    This captures the change in consumption due purely to the change in
    purchasing power (real income) accompanying a price change. -/
noncomputable def income_effect {L : ℕ} (total_effect substitution_effect : Fin L → Fin L → ℝ) :
    Fin L → Fin L → ℝ :=
  fun l k => total_effect l k - substitution_effect l k