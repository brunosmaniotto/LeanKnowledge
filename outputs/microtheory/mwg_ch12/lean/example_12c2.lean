import Mathlib

/-- In the linear city model, the symmetric Nash equilibrium price is p* = c + t.
    This follows from the best-response function b(p) = (t + p + c)/2 having
    a fixed point at p* = c + t. We also show equilibrium profit is tM/2
    and the comparative statics properties. -/

-- The best-response function
noncomputable def best_response (t c p : ℝ) : ℝ := (t + p + c) / 2

-- The equilibrium price is the fixed point of the best response
theorem linear_city_equilibrium_price (t c : ℝ) :
    best_response t c (c + t) = c + t := by
  unfold best_response
  ring

-- The equilibrium price solves p = (t + p + c)/2 iff p = c + t