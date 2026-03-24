import Mathlib

-- MWG Definition M.F.2: A function f : X → ℝ is continuous on X.
def MWG.IsContinuousOn {K : ℕ} (X : Set (Fin K → ℝ)) (f : (Fin K → ℝ) → ℝ) : Prop :=
  ContinuousOn f X

-- MWG Definition M.F.2 (vector-valued): f : X → ℝ^N is continuous on X
-- iff every coordinate function is continuous on X.