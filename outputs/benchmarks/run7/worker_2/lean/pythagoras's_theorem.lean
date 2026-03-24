import Mathlib

-- Sub-lemma 1: Distance squared as norm squared
lemma distance_squared_as_norm_squared {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V] (A B : V) : 
  dist A B ^ 2 = ‖A - B‖^2 := by
  rw [dist_eq_norm]

-- Sub-lemma 2: Right angle characterization via inner product