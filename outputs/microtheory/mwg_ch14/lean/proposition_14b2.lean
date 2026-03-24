import Mathlib
open Topology

noncomputable section

theorem Proposition_14B2
    (π_exp : ℝ → ℝ)
    (g : ℝ → ℝ)
    (u_bar : ℝ)
    (e_star : ℝ)
    (h_fb : ∀ e, π_exp e_star - g e_star ≥ π_exp e - g e)
    (h_pc : π_exp e_star - g e_star ≥ u_bar) :
    let α_star := π_exp e_star - g e_star - u_bar;
    (∀ e, (π_exp e_star - α_star - g e_star) ≥ (π_exp e - α_star - g e))
    ∧ (π_exp e_star - α_star - g e_star = u_bar)
    ∧ (α_star = π_exp e_star - g e_star - u_bar) := by
  intro α_star
  refine ⟨?_, ?_, ?_⟩
  · intro e
    have h := h_fb e
    linarith
  · ring
  · ring