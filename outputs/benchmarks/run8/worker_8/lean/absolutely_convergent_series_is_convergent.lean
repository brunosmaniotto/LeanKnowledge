import Mathlib

variable {V : Type} [NormedAddCommGroup V] [CompleteSpace V] {a : ℕ → V}

theorem Absolutely_Convergent_Series_is_Convergent (h : Summable (fun n => ‖a n‖)) : Summable a :=
  Summable.of_norm h