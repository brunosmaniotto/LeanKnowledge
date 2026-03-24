import Mathlib
open Finset
open BigOperators
open Topology

set_option linter.unusedVariables false

theorem claim_5_2_walras_n_general_part_i {n : ℕ} (p z : Fin n → ℝ) 
    (hwalras : ∑ i, p i * z i = 0) : 
    (∃ i, 0 < p i * z i) → ∃ j, p j * z j < 0 := by
  intro h_exists
  rcases h_exists with ⟨i, hi⟩
  by_contra! h_nonneg  -- h_nonneg : ∀ j, ¬ (p j * z j < 0) → equivalently ∀ j, 0 ≤ p j * z j
  have h_all : ∀ j, 0 ≤ p j * z j := by
    intro j
    have := h_nonneg j
    linarith
  have hsum_pos : 0 < ∑ i, p i * z i :=
    lt_of_lt_of_le hi (Finset.single_le_sum (fun j _ => h_all j) (Finset.mem_univ i))
  linarith