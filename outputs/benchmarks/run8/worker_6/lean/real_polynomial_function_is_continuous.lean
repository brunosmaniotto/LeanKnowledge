import Mathlib

open Polynomial

theorem Real_Polynomial_Function_is_Continuous (p : ℝ[X]) : Continuous (fun x : ℝ => p.eval x) :=
  Polynomial.continuous p