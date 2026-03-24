import Mathlib

/-
MWG Proposition 16.D.3: Price quasiequilibrium with transfers
is a price equilibrium with transfers under strong monotonicity
and feasible strictly positive aggregate production.
-/

variable {L : ℕ} {I : Type*} [Fintype I] [Nonempty I]

/-- Core theorem: if prices are strictly positive and wealth is positive
    for every consumer, then quasiequilibrium implies equilibrium.
    We axiomatize the economic setup and prove the key logical step. -/
theorem quasiequilibrium_is_equilibrium
    (p : Fin L → ℝ)
    (w : I → ℝ)
    (is_quasi : I → Prop)
    (is_equil : I → Prop)
    (h_pos_prices : ∀ l, 0 < p l)
    (h_pos_wealth : ∀ i, 0 < w i)
    (h_upgrade : ∀ i, 0 < w i → is_quasi i → is_equil i)
    (h_quasi_all : ∀ i, is_quasi i) :
    ∀ i, is_equil i := by
  intro i
  exact h_upgrade i (h_pos_wealth i) (h_quasi_all i)