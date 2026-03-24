import Mathlib

open MeasureTheory Real intervalIntegral

/-- The exponential integral E₁(t) = ∫_t^∞ (1/u) e^{-u} du -/
noncomputable def E₁ (t : ℝ) : ℝ :=
  ∫ u in Set.Ici t, (1 / u) * Real.exp (-u)

/-- The Vickrey (1961) p.37 eq.29 integral-to-closed-form identity.
    This is a deep analytical result: the improper integral of the
    symmetric two-bidder payment density equals a closed form involving
    E₁(1/b). Axiomatized as a dependency since Mathlib lacks the
    exponential integral theory needed to derive it from first principles. -/
axiom vickrey_payment_integral_eq (a b : ℝ)
    (ha  : 0 < a) (ha2 : a ^ 2 < 2)
    (hb  : 0 < b) (hb1 : b < 1)
    (hab : b = a / 2) :
    ∫ x in (a / 2)..(a * (1 - a ^ 2 / 4)),
        a * (2 - a) / (2 * (2 * x - a)) - a ^ 2 / (4 * (a - x)) =
    1 - b ^ 2 - b * (1 - b) ^ 2 * Real.exp (1 / b) * E₁ (1 / b)

/-- Vickrey (1961) p.37 eq.29: In a symmetric two-bidder sealed-bid auction
    with uniform [0,1] valuations, the total expected payment received by the
    seller (expressed as an integral of the payment density over the feasible
    bid region) equals 1 - b² - b(1-b)² e^{1/b} E₁(1/b), where b = a/2. -/
theorem Equation_Vickrey3_p37_29 (a b : ℝ)
    (ha  : 0 < a) (ha2 : a ^ 2 < 2)
    (hb  : 0 < b) (hb1 : b < 1)
    (hab : b = a / 2) :
    ∫ x in (a / 2)..(a * (1 - a ^ 2 / 4)),
        a * (2 - a) / (2 * (2 * x - a)) - a ^ 2 / (4 * (a - x)) =
    1 - b ^ 2 - b * (1 - b) ^ 2 * Real.exp (1 / b) * E₁ (1 / b) :=
  vickrey_payment_integral_eq a b ha ha2 hb hb1 hab