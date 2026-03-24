import Mathlib

open Filter Topology

theorem Claim_Lemma82_case2_detail
    (u_h_psi_beta_h u_h_psi_star_h u_h_psi_star_l : ℝ)
    (u_h_psi_eps_l : ℝ → ℝ)
    (h_strict : u_h_psi_beta_h > u_h_psi_star_h)
    (h_equil : u_h_psi_star_h ≥ u_h_psi_star_l)
    (h_limit : Tendsto u_h_psi_eps_l (nhdsWithin 0 (Set.Ioi 0)) (nhds u_h_psi_star_l)) :
    ∃ ε : ℝ, ε > 0 ∧ u_h_psi_beta_h > u_h_psi_eps_l ε := by
  have h_gt : u_h_psi_star_l < u_h_psi_beta_h := by linarith
  have h_ev : ∀ᶠ ε in nhdsWithin (0 : ℝ) (Set.Ioi 0), u_h_psi_eps_l ε < u_h_psi_beta_h :=
    h_limit (Iio_mem_nhds h_gt)
  have h_pos : ∀ᶠ ε in nhdsWithin (0 : ℝ) (Set.Ioi 0), (0 : ℝ) < ε := self_mem_nhdsWithin
  obtain ⟨ε, hlt, hpos⟩ := (h_ev.and h_pos).exists
  exact ⟨ε, hpos, hlt⟩