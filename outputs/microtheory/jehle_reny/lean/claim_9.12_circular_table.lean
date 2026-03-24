import Mathlib
open Finset
open scoped BigOperators
open BigOperators
set_option linter.unusedVariables false

noncomputable section

/-- Budget balance for the circular-table reallocation from Theorem 9.12.
    The N individual cost adjustments c^B_i sum to zero since all payments
    are internal transfers — no money leaves or enters the system. -/
theorem Claim_9_12_circular_table {N : ℕ} (hN : 0 < N)
    (f g : Fin N → ℝ) (next : Equiv.Perm (Fin N)) :
    ∑ i : Fin N, (f i - f (next i) + g (next i) - (1 / ↑N : ℝ) * ∑ j, g j) = 0 := by
  have hN' : (↑N : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hN.ne'
  have h1 : ∑ i : Fin N, f (next i) = ∑ i, f i := Equiv.sum_comp next f
  have h2 : ∑ i : Fin N, g (next i) = ∑ i, g i := Equiv.sum_comp next g
  simp only [Finset.sum_sub_distrib, Finset.sum_add_distrib, Finset.sum_const,
    Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
  rw [h1, h2]
  field_simp
  ring