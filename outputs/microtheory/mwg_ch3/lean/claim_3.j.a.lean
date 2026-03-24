import Mathlib

theorem wa_equiv_sa_when_L_eq_2
    (R : Fin 2 → Fin 2 → Prop) [DecidableRel R]
    (hWA : ∀ x y, R x y → ¬ R y x) :
    WellFounded R := by
  constructor
  intro x
  fin_cases x <;> {
    constructor; intro y hy
    fin_cases y
    all_goals (first | exact absurd hy (hWA _ _ ‹_›) | skip)
    all_goals {
      constructor; intro z hz
      fin_cases z
      all_goals (first | exact absurd hz (hWA _ _ ‹_›) | exact absurd ‹_› (hWA _ _ hz))
    }
  }