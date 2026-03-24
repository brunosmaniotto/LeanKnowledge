import Mathlib

open Real

/-- In a first-price sealed-bid auction with uniform valuations on [0,b],
the general solution to the bidding ODE is x(v) = v/2 + c/v.
The bound conditions (0 ≤ x(v) ≤ v, i.e. -(v²) ≤ 2c ≤ v² for all v > 0)
force c = 0, yielding the equilibrium bidding rule x(v) = v/2. -/
theorem claim_vickrey3_p32_d (b : ℝ) (hb : 0 < b) (c : ℝ)
    (x : ℝ → ℝ)
    (hx : ∀ v : ℝ, 0 < v → x v = v / 2 + c / v)
    (h_lower : ∀ v : ℝ, 0 < v → -(v ^ 2) ≤ 2 * c)
    (h_upper : ∀ v : ℝ, 0 < v → 2 * c ≤ v ^ 2) :
    c = 0 ∧ ∀ v : ℝ, 0 < v → v ≤ b → x v = v / 2 := by
  have hc : c = 0 := by
    by_contra hne
    obtain hcn | hcp := lt_or_gt_of_ne hne
    · -- c < 0: evaluate h_lower at v = √(-c)
      have hm : (0 : ℝ) < -c := neg_pos.mpr hcn
      have := h_lower (sqrt (-c)) (by positivity)
      rw [sq_sqrt hm.le] at this
      linarith
    · -- c > 0: evaluate h_upper at v = √c
      have := h_upper (sqrt c) (by positivity)
      rw [sq_sqrt (le_of_lt hcp)] at this
      linarith
  exact ⟨hc, fun v hv _ => by simp [hx v hv, hc]⟩