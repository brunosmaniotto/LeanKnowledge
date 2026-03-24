import Mathlib
open Topology

/-- Complementary slackness in 1D: For max f(x) s.t. x ≥ 0, the KKT conditions
    (f'(x*) ≤ 0, x*·f'(x*) = 0, x* ≥ 0) imply x*=0 or f'(x*)=0.
    The product condition alone is insufficient: at x̃=0 with f'(0)>0,
    the product vanishes but f'≤0 is violated (boundary minimum, not maximum). -/
theorem Claim_A2_ComplementarySlackness1D :
    -- Part 1: KKT conditions imply either x*=0 (boundary) or f'(x*)=0 (interior)
    (∀ x df : ℝ, df ≤ 0 → x * df = 0 → 0 ≤ x → (x = 0 ∨ df = 0)) ∧
    -- Part 2: Product condition alone is insufficient —
    -- counterexample: x=0, f'(0)>0 satisfies x·f'(x)=0 and x≥0 but violates f'≤0
    (∃ x df : ℝ, 0 ≤ x ∧ x * df = 0 ∧ df > 0) :=
  ⟨fun _ _ _ h _ => mul_eq_zero.mp h,
   ⟨0, 1, le_refl 0, by ring, by norm_num⟩⟩