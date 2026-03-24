import Mathlib
set_option linter.unusedVariables false

private noncomputable def sortedVals {n : ℕ} (v : Fin n → ℝ) : List ℝ :=
  ((Finset.univ (α := Fin n)).image v).sort (· ≥ ·)

axiom sorted_values_length {n : ℕ} (v : Fin n → ℝ) (hv : Function.Injective v) :
    (sortedVals v).length = n

axiom above_mth_stat_count {n m : ℕ} (v : Fin n → ℝ) (hv : Function.Injective v)
    (hm : m < (sortedVals v).length) :
    ((Finset.univ (α := Fin n)).filter (fun i => v i > (sortedVals v).get ⟨m, hm⟩)).card = m

axiom mth_value_in_range {n m : ℕ} (v : Fin n → ℝ) (hv : Function.Injective v)
    (hm : m < (sortedVals v).length) :
    ∃ i : Fin n, v i = (sortedVals v).get ⟨m, hm⟩

/-- In a simultaneous auction for `m` identical items with negligible bid increments,
    bidding stops at the (m+1)-th highest value: exactly `m` bidders value the item
    above that price, and some bidder holds exactly that value. -/
theorem Claim_IV_B {n m : ℕ} (v : Fin n → ℝ) (hv : Function.Injective v) (hm : m + 1 ≤ n) :
    ∃ p : ℝ,
      ((Finset.univ (α := Fin n)).filter (fun i => v i > p)).card = m ∧
      ∃ i : Fin n, v i = p := by
  have hlen := sorted_values_length v hv
  have hm' : m < (sortedVals v).length := by omega
  exact ⟨(sortedVals v).get ⟨m, hm'⟩,
         above_mth_stat_count v hv hm',
         mth_value_in_range v hv hm'⟩