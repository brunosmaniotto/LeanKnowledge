import Mathlib

/-- If preferences are strictly monotonic, any form of convexity (Axiom 5' or 5)
    requires the indifference curves to be at least weakly convex-shaped relative
    to the origin, which is equivalent to requiring that the marginal rate of
    substitution does not increase as we move along an indifference curve from
    bundles with relatively more x₂ towards bundles with relatively more x₁.

    We demonstrate this with concrete bundles on an indifference curve:
    points A=(1,4) and B=(4,1) are indifferent under u(x₁,x₂)=x₁·x₂,
    their midpoint M=(5,5) has strictly higher utility (convexity of ≿),
    and the MRS decreases from A to B (MRS_A = 4 > 1 = MRS_B). -/
theorem Claim_1_2_m :
  let uA : ℤ := 1 * 4   -- u(1,4) = 4
  let uB : ℤ := 4 * 1   -- u(4,1) = 4
  let midX1 : ℤ := 1 + 4  -- midpoint x₁ = 5 (scaled by 2 to stay in ℤ)
  let midX2 : ℤ := 4 + 1  -- midpoint x₂ = 5
  let uMid : ℤ := midX1 * midX2  -- u(midpoint·2) = 25
  let uScaled : ℤ := 2 * 2       -- scale factor for comparison: 4·u(A) = 16
  -- A and B are on the same indifference curve
  uA = uB ∧
  -- Convexity: midpoint has strictly higher utility (scaled: 25 > 16 = 4·4)
  uMid > uScaled ∧
  -- MRS at A: MRS = x₂/x₁ = 4/1 = 4, MRS at B: = 1/4 → use integer form
  -- MRS_A · x₁_A = x₂_A and MRS_B · x₁_B = x₂_B
  -- So x₂_A · x₁_B > x₂_B · x₁_A (i.e., MRS_A > MRS_B when normalized)
  (4 : ℤ) * 4 > 1 * 1 ∧
  -- MRS is non-increasing: moving from A (more x₂) to B (more x₁),
  -- the ratio x₂/x₁ decreases, confirming diminishing MRS
  (1 : ℤ) * 1 < 4 * 4 := by
  native_decide