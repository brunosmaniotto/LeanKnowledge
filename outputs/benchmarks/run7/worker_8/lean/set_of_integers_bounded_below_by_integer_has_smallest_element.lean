import Mathlib

-- Sub-lemma 1: Shifting an element by a lower bound results in a non-negative integer.
lemma step1_shifted_element_is_nonneg (m : ℤ) {s : ℤ} (h_lower_bound : m ≤ s) : 0 ≤ s - m := by
  exact sub_nonneg_of_le h_lower_bound

-- Sub-lemma 2: The image of a non-empty set is non