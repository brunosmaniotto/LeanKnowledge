import Mathlib

open ContinuousLinearMap

theorem implicit_function_equilibrium_derivative
    {K : Type*} [NontriviallyNormedField K]
    {P : Type*} [NormedAddCommGroup P] [NormedSpace K P] [CompleteSpace P]
    {Q : Type*} [NormedAddCommGroup Q] [NormedSpace K Q] [CompleteSpace Q]
    {Z : Type*} [NormedAddCommGroup Z] [NormedSpace K Z] [CompleteSpace Z]
    (Dp : P →L[K] Z) (Dq : Q →L[K] Z)
    (Dp_inv : Z →L[K] P)
    (hLeft : Dp_inv.comp Dp = ContinuousLinearMap.id K P)
    (hRight : Dp.comp Dp_inv = ContinuousLinearMap.id K Z)
    : Dp.comp ((-1 : K) • (Dp_inv.comp Dq)) = (-1 : K) • Dq := by
  rw [comp_smul]
  congr 1
  rw [← comp_assoc, hRight, id_comp]