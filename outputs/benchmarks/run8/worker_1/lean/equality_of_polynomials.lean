import Mathlib

-- Axiomatized sub-lemmas (as given in the problem description)

-- If two polynomials are equal as polynomial objects, they are equal as functions.
-- This is true over any commutative semiring.
axiom poly_eq_implies_fun_eq {R : Type*} [CommSemiring R] {f g : Polynomial R} (h_eq : f = g) : ∀ (x : R), f.eval x = g.eval x

-- If two polynomials are equal as functions over an infinite integral domain,
-- they are equal as polynomial objects.
axiom fun_eq_implies_poly_eq {R : Type*} [CommRing R] [IsDomain R] [Infinite R] {f g : Polynomial R} (h_fun_eq : ∀ (x : R), f.eval x = g.eval x) : f = g

-- Main theorem
-- Equality of polynomials is equivalent to equality of the functions they represent,
-- provided the ring is an infinite integral domain.
theorem polynomial_equality_iff_function_equality {R : Type*} [CommRing R] [IsDomain R] [Infinite R] (f g : Polynomial R) : f = g ↔ ∀ (x : R), f.eval x = g.eval x := by
  -- To prove an "iff" statement (↔), we prove both directions using the `constructor` tactic.
  constructor
  · -- Direction 1: `f = g → ∀ (x : R), f.eval x = g.eval x`
    -- We assume `f = g` and need to show they are equal as functions.
    intro h_poly_eq
    -- This is a direct application of the first axiom.
    exact poly_eq_implies_fun_eq h_poly_eq
  · -- Direction 2: `(∀ (x : R), f.eval x = g.eval x) → f = g`
    -- We assume `f` and `g` are equal as functions and need to show they are equal as polynomials.
    intro h_fun_eq
    -- This is a direct application of the second axiom.
    exact fun_eq_implies_poly_eq h_fun_eq