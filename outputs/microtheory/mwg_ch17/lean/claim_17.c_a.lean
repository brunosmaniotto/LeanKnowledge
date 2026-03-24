import Mathlib

/-- For the case L = 2 (two commodities), the existence of an equilibrium follows
from the intermediate value theorem: normalizing p₂ = 1, when p₁ is very small
z₁(p₁, 1) > 0, and when p₁ is very large z₁(p₁, 1) < 0. By continuity, there
exists an intermediate p₁* with z₁(p₁*, 1) = 0. -/
theorem excess_demand_ivt_equilibrium
    (z : ℝ → ℝ) (hz : Continuous z)
    (a b : ℝ) (hab : a < b)
    (hza : 0 < z a) (hzb : z b < 0) :
    ∃ p : ℝ, a ≤ p ∧ p ≤ b ∧ z p = 0 := by
  have hab' : a ≤ b := le_of_lt hab
  have himg : IsPreconnected (z '' Set.Icc a b) :=
    isPreconnected_Icc.image z hz.continuousOn
  have hza_mem : z a ∈ z '' Set.Icc a b :=
    Set.mem_image_of_mem z (Set.left_mem_Icc.mpr hab')
  have hzb_mem : z b ∈ z '' Set.Icc a b :=
    Set.mem_image_of_mem z (Set.right_mem_Icc.mpr hab')
  rw [isPreconnected_iff_ordConnected] at himg
  have h0 : (0 : ℝ) ∈ z '' Set.Icc a b :=
    himg.out hzb_mem hza_mem ⟨le_of_lt hzb, le_of_lt hza⟩
  obtain ⟨p, hp_mem, hp_eq⟩ := h0
  exact ⟨p, hp_mem.1, hp_mem.2, hp_eq⟩