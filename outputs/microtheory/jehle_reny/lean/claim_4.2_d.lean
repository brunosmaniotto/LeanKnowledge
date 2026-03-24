import Mathlib

/-- The Lerner index: monopoly markup (p−mc)/p = 1/|ε|, and price exceeds marginal cost
    when demand is finitely elastic. -/
theorem Claim_4_2_d
    (p mc ε : ℝ)
    (hp : p ≠ 0)
    (hε : ε ≠ 0)
    (hε_neg : ε < 0)
    (foc : p * (1 + 1 / ε) = mc) :
    (p - mc) / p = 1 / |ε| ∧ (0 < p → mc < p) := by
  have habs : |ε| = -ε := abs_of_neg hε_neg
  -- From FOC: p(1 + 1/ε) = mc  ⟹  mc = p + p/ε
  have hmc : mc = p + p / ε := by
    have := foc; field_simp [hε] at this ⊢; linarith
  constructor
  · -- Lerner index: (p − mc)/p = 1/|ε|
    rw [habs, hmc]; field_simp [hp, hε]; ring
  · -- Price exceeds MC when demand is less than infinitely elastic
    intro hp_pos
    have := div_neg_of_pos_of_neg hp_pos hε_neg
    linarith