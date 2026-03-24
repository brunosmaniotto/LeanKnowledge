import Mathlib

noncomputable section

/-- In any sequential equilibrium, the high-risk consumer must purchase insurance.
    Without insurance, expected utility π̄·u(w-L) + (1-π̄)·u(w) < u(w - π̄L) = u^c_h
    by strict concavity (Jensen), and u*_h ≥ u^c_h by Lemma 8.1(2). -/
theorem claim_8_1_2_h
    (u : ℝ → ℝ) (w L π_bar u_star_h : ℝ)
    (hπ_pos : 0 < π_bar) (hπ_lt : π_bar < 1)
    (hu : StrictConcaveOn ℝ Set.univ u)
    (hL : w - L ≠ w)
    (h_star : u_star_h ≥ u (π_bar * (w - L) + (1 - π_bar) * w)) :
    π_bar * u (w - L) + (1 - π_bar) * u w < u_star_h := by
  have h1 : (0 : ℝ) < 1 - π_bar := by linarith
  have h2 : π_bar + (1 - π_bar) = 1 := by ring
  have h_jensen := hu.2 (Set.mem_univ (w - L)) (Set.mem_univ w) hL hπ_pos h1 h2
  simp only [smul_eq_mul] at h_jensen
  linarith