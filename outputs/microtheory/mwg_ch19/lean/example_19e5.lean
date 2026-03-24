import Mathlib

open Matrix

/-- The return of a call option with strike price k on a primary asset with return r:
    max(r - k, 0) -/
noncomputable def callOptionReturn (r : ℚ) (k : ℚ) : ℚ := max (r - k) 0

/-- Example 19.E.5: With S=4 states and primary asset returns (4,3,2,1),
    the matrix formed by the primary asset plus call options at strikes 3.5, 2.5, 1.5
    has nonzero determinant, so the asset structure is complete. -/
theorem Example_19E5 :
    let M : Matrix (Fin 4) (Fin 4) ℚ :=
      !![4, 1/2, 3/2, 5/2;
         3, 0,   1/2, 3/2;
         2, 0,   0,   1/2;
         1, 0,   0,   0]
    M.det ≠ 0 := by
  native_decide