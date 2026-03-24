import Mathlib

theorem trembling_hand_mild_robustness
    {Perturbation : Type*} [Nonempty Perturbation]
    (close_to_original : Perturbation → Prop)
    (has_nearby_equilibrium : Perturbation → Prop)
    (h_exists_close : ∃ p, close_to_original p)
    : (∀ p, close_to_original p → has_nearby_equilibrium p) →
      (∃ p, close_to_original p ∧ has_nearby_equilibrium p) := by
  intro h_univ
  obtain ⟨p, hp⟩ := h_exists_close
  exact ⟨p, hp, h_univ p hp⟩