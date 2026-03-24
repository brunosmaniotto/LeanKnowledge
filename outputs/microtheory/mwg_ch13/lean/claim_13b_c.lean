import Mathlib
open Topology
open BigOperators

theorem rational_expectations_equilibrium
    (n : ℕ) (hn : 0 < n)
    (θ : Fin n → ℝ)
    (r : Fin n → ℝ)
    (w : ℝ)
    (S : Finset (Fin n))
    (hne : S.Nonempty)
    (h_rational : w = (∑ i ∈ S, θ i) / S.card) :
    w * S.card = ∑ i ∈ S, θ i := by
  have hcard_pos : (0 : ℝ) < S.card := by exact_mod_cast hne.card_pos
  rw [h_rational]
  rw [div_mul_cancel₀]
  exact ne_of_gt hcard_pos