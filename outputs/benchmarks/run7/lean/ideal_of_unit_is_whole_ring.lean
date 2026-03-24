import Mathlib

theorem ideal_of_unit_is_whole_ring {R : Type u} [Ring R] (J : Ideal R)
    (h_unit_in_ideal : ∃ u : R, IsUnit u ∧ u ∈ J) : J = ⊤ := by
  rcases h_unit_in_ideal with ⟨u, hu, huJ⟩
  have h1 : (1 : R) ∈ J := by
    rcases hu.exists_left_inv with ⟨v, hv⟩
    rw [← hv]
    exact J.mul_mem_left v huJ
  rw [Ideal.eq_top_iff_one]
  exact h1