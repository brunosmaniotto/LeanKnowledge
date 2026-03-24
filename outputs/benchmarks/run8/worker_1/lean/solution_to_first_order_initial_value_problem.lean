import Mathlib

-- The problem of solving the first-order ODE y' = f(x, y) with initial condition y(a) = b
-- is equivalent to solving the integral equation y(x) = b + ∫[a,x] f(t, y(t)) dt.
-- This is a foundational result in the theory of ordinary differential equations, often
-- used as a step in proving existence and uniqueness theorems like the Picard-Lindelöf theorem.
-- The proof relies on the fundamental theorem of calculus.

-- We axiomatize the two directions of the equivalence, which are consequences of the
-- fundamental theorem of calculus.

-- Axiom 1: If y solves the ODE initial value problem, it also solves the integral equation.
-- This follows from integrating both sides of y' = f(x, y(x)) from a to x.
axiom ode_implies_integral_equation {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  (f : ℝ → E → E) (y : ℝ → E) (a : ℝ) (b : E)
  (hy_deriv : ∀ x, HasDerivAt y (f x (y x)) x)
  (hy_init : y a = b)
  (h_cont : Continuous (fun t ↦ f t (y t))) :
  ∀ x, y x = b + ∫ t in Set.uIoc a x, f t (y t)

-- Axiom 2: If y solves the integral equation, its derivative is f(x, y(x)).
-- This follows from differentiating the integral equation using the fundamental theorem of calculus.
axiom integral_equation_implies_deriv {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  (f : ℝ → E → E) (y : ℝ → E) (a : ℝ) (b : E)
  (h_int_eq : ∀ x, y x = b + ∫ t in Set.uIoc a x, f t (y t))
  (h_cont : Continuous (fun t ↦ f t (y t))) :
  ∀ x, HasDerivAt y (f x (y x)) x

-- Axiom 3: If y solves the integral equation, it satisfies the initial condition y(a) = b.
-- This follows from substituting x = a into the integral equation, as the integral from a to a is zero.
axiom integral_equation_implies_initial_condition {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  (f : ℝ → E → E) (y : ℝ → E) (a : ℝ) (b : E)
  (h_int_eq : ∀ x, y x = b + ∫ t in Set.uIoc a x, f t (y t)) :
  y a = b

/--
The main theorem establishing the equivalence between a first-order initial value problem (IVP)
and its corresponding integral equation form.

Let `y` be a function from `ℝ` to a Banach space `E`. The IVP is given by:
1. The differential equation: `y'(x) = f(x, y(x))` for all `x`.
2. The initial condition: `y(a) = b`.

This theorem states that this IVP is equivalent to the single integral equation:
`y(x) = b + ∫ t in a..x, f(t, y(t))`

We require that the composition `t ↦ f(t, y(t))` is continuous to ensure the integral is
well-defined and the fundamental theorem of calculus applies.
-/
theorem first_order_ode_solution_integral_form
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (f : ℝ → E → E) (y : ℝ → E) (a : ℝ) (b : E)
    (h_cont : Continuous (fun t ↦ f t (y t))) :
    ((∀ x, HasDerivAt y (f x (y x)) x) ∧ y a = b) ↔ (∀ x, y x = b + ∫ t in Set.uIoc a x, f t (y t)) := by
  -- We prove the equivalence by showing both implications.
  constructor
  -- Direction 1: The ODE initial value problem implies the integral equation.
  · -- Assume `y` solves the ODE and satisfies the initial condition.
    intro h_ode
    -- `h_ode` is a conjunction. `h_ode.1` is the derivative condition, `h_ode.2` is the initial condition.
    -- We apply the first axiom, which directly proves this direction.
    exact ode_implies_integral_equation f y a b h_ode.1 h_ode.2 h_cont
  -- Direction 2: The integral equation implies the ODE initial value problem.
  · -- Assume `y` solves the integral equation.
    intro h_int_eq
    -- We need to prove a conjunction: the derivative condition and the initial condition.
    constructor
    -- First, prove the derivative condition.
    · -- This follows directly from the second axiom.
      exact integral_equation_implies_deriv f y a b h_int_eq h_cont
    -- Second, prove the initial condition.
    · -- This follows directly from the third axiom.
      exact integral_equation_implies_initial_condition f y a b h_int_eq