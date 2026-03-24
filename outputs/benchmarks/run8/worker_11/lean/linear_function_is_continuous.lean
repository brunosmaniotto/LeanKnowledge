import Mathlib

theorem linear_function_continuous (α β : ℝ) (c : ℝ) :
    ContinuousAt (fun x : ℝ => α * x + β) c :=
  ((continuous_const.mul continuous_id).add continuous_const).continuousAt