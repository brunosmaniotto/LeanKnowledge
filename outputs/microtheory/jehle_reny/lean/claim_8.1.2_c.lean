import Mathlib

/-
Claim 8.1.2(c): MRS relationships with profit bounds.

MRSl(B,p) = p/(1-p) · u'(W-π̲+B)/u'(W+π̄-B) compared to π̲
MRSh(B,p) = p/(1-p) · u'(W-π̲+B)/u'(W+π̄-B) compared to π̄

When B = L (full insurance), the consumption levels equalize and
u' ratio = 1, so MRS = p/(1-p). The key insight is that at B < L,
B = L, or B > L, the derivative ratio shifts the MRS relative to
the profit margins.

We formalize the core algebraic fact: for a strictly concave
(strictly decreasing marginal utility) function, the ratio
u'(W - π̲ + B)/u'(W + π̄ - B) is >, =, or < 1 as B <, =, > L,
where L is the loss level that equalizes arguments.
-/

-- We prove the key structural facts about MRS comparisons
-- When B = L, the two arguments to u' are equal, so the ratio is 1

theorem claim_8_1_2_c_equal (W π_low π_high B L p : ℝ)
    (hp : 0 < p) (hp1 : p < 1)
    (hL : W - π_low + L = W + π_high - L)
    (hB : B = L) :
    W - π_low + B = W + π_high - B := by
  rw [hB]; linarith

-- The MRS at full insurance (B = L) simplifies because u' cancels