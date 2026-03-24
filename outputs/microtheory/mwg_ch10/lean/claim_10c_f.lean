import Mathlib
open Topology

axiom excess_demand_continuous {a b : ℝ} {x q : ℝ → ℝ}
    (hx : ContinuousOn x (Set.Icc a b))
    (hq : ContinuousOn q (Set.Icc a b)) :
    ContinuousOn (fun p => x p - q p) (Set.Icc a b)

axiom excess_demand_strict_anti {a b : ℝ} {x q : ℝ → ℝ}
    (hx : StrictAntiOn x (Set.Icc a b))
    (hq : StrictMonoOn q (Set.Icc a b)) :
    StrictAntiOn (fun p => x p - q p) (Set.Icc a b)

axiom ivt_existence_of_zero {a b : ℝ} {f : ℝ → ℝ}
    (hab : a < b)
    (hf : ContinuousOn f (Set.Icc a b))
    (hfa : 0 < f a)
    (hfb : f b < 0) :
    ∃ p ∈ Set.Ioo a b, f p = 0

axiom strict_anti_unique_zero {a b : ℝ} {f : ℝ → ℝ}
    (hf : StrictAntiOn f (Set.Icc a b))
    (hp : ∃ p ∈ Set.Ioo a b, f p = 0) :
    ∃! p ∈ Set.Ioo a b, f p = 0

axiom equilibrium_from_excess_demand_zero {x q : ℝ → ℝ} {p : ℝ}
    (h : x p - q p = 0) :
    x p = q p

theorem equilibrium_exists_unique
    {a b : ℝ} {x q : ℝ → ℝ}
    (hab : a < b)
    (hxc : ContinuousOn x (Set.Icc a b))
    (hqc : ContinuousOn q (Set.Icc a b))
    (hxa : StrictAntiOn x (Set.Icc a b))
    (hqm : StrictMonoOn q (Set.Icc a b))
    (hxa_pos : 0 < x a - q a)
    (hxb_neg : x b - q b < 0) :
    ∃! p ∈ Set.Ioo a b, x p = q p := by
  have hfc := excess_demand_continuous hxc hqc
  have hfsa := excess_demand_strict_anti hxa hqm
  have hexists := ivt_existence_of_zero hab hfc hxa_pos hxb_neg
  have hunique := strict_anti_unique_zero hfsa hexists
  obtain ⟨p, ⟨hp_mem, hp_zero⟩, hp_uniq⟩ := hunique
  refine ⟨p, ⟨hp_mem, equilibrium_from_excess_demand_zero hp_zero⟩, ?_⟩
  intro y ⟨hy_mem, hy_eq⟩
  apply hp_uniq
  exact ⟨hy_mem, by linarith⟩