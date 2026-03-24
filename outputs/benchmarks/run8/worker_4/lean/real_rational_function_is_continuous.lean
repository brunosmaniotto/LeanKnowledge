import Mathlib

open Polynomial

theorem real_rational_function_continuous_at (P Q : ℝ[X]) (c : ℝ) (hQc : Q.eval c ≠ 0) :
    ContinuousAt (fun x => (P.eval x) / (Q.eval x)) c := by
  have hP : Continuous fun x => P.eval x := P.continuous
  have hQ : Continuous fun x => Q.eval x := Q.continuous
  exact ContinuousAt.div hP.continuousAt hQ.continuousAt hQc