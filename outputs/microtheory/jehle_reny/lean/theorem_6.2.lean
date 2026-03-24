import Mathlib

open Filter Topology Continuous
open Topology

variable {I : ℕ} [hI : Fact (0 < I)] -- I must be positive for Finset.univ to be non-empty

-- Re-defining Hammond Equity for clarity and to match the prompt's input
-- Definition_6.3_HE
/-- Hammond Equity (HE): A social welfare function W satisfies HE if
    when two distinct utility vectors ū and ũ differ only for individuals i and j,
    and the utilities {ūᵢ, ūⱼ} are "compressed" to {ũᵢ, ũⱼ} such that ūᵢ < ũᵢ < ũⱼ < ūⱼ,
    then the welfare does not decrease. -/
def HammondEquity (W : (Fin I → ℝ) → ℝ) : Prop :=
  ∀ (u u' : Fin I → ℝ) (i j : Fin I),
    i ≠ j →
    (∀ k : Fin I, k ≠ i ∧ k ≠ j → u k = u' k) →
    u i < u' i → u' i < u' j → u' j < u j →
    W u' ≥ W u

-- Re-defining IsParetian as provided in the reference, for "strictly increasing"
/-- A social welfare function W : (Fin I → ℝ) → ℝ satisfies the Paretian property
    if it is increasing: weak dominance implies weak inequality of welfare,
    and strict dominance implies strict inequality of welfare. -/
structure IsParetian (W : (Fin I → ℝ) → ℝ) : Prop where
  weak : ∀ u u' : Fin I → ℝ, (∀ i, u i ≤ u' i) → W u ≤ W u'
  strict : ∀ u u' : Fin I → ℝ, (∀ i, u i < u' i) → W u < W u'

-- Rawlsian form definition