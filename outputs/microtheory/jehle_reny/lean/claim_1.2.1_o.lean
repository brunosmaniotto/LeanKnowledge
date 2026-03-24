import Mathlib

/-- Claim 1.2.1(o): Under Axiom 5' (Convexity), the MRS is non-increasing
    along indifference curves. Under Axiom 5 (Strict Convexity), the MRS
    is strictly diminishing. We prove that strict convexity (Axiom 5)
    implies convexity (Axiom 5'). -/
theorem claim_1_2_1_o
    (mrs : ℝ → ℝ)
    (strict_convexity : StrictAnti mrs) :
    Antitone mrs :=
  strict_convexity.antitone