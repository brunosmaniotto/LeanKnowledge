import Mathlib
open Topology

/-- Given positive marginal utilities u', v' and the Arrow-Pratt condition
    -u''/u' > -v''/v', the composition h = u ∘ v⁻¹ satisfies h' > 0 and h'' < 0.
    This proves the algebraic core: h'(x) = u'/v' > 0 and
    h''(x) = u'·(u''/u' - v''/v') / (v')² < 0. -/
theorem claim_2_4_3_f
    (u' v' u'' v'' : ℝ)
    (hu' : 0 < u')
    (hv' : 0 < v')
    (hRA : -u'' / u' > -v'' / v') :
    0 < u' / v' ∧
    u' * (u'' / u' - v'' / v') / v' ^ 2 < 0 := by
  refine ⟨div_pos hu' hv', ?_⟩
  have h1 : u'' / u' < v'' / v' := by
    have h := hRA
    rw [gt_iff_lt, neg_div, neg_div, neg_lt_neg_iff] at h
    exact h
  exact div_neg_of_neg_of_pos
    (mul_neg_of_pos_of_neg hu' (sub_neg.mpr h1))
    (pow_pos hv' 2)