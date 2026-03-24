import Mathlib

open Filter Topology

theorem tendsto_nhds_unique_of_metric {X : Type} [MetricSpace X] {u : ℕ → X} {l m : X}
    (hl : Tendsto u atTop (𝓝 l)) (hm : Tendsto u atTop (𝓝 m)) : l = m := by
  apply eq_of_forall_dist_le
  intro ε hε
  have hε2 : 0 < ε / 2 := by linarith
  have h1 := Metric.tendsto_nhds.1 hl (ε / 2) hε2
  have h2 := Metric.tendsto_nhds.1 hm (ε / 2) hε2
  rcases eventually_atTop.1 h1 with ⟨N1, hN1⟩
  rcases eventually_atTop.1 h2 with ⟨N2, hN2⟩
  set N := max N1 N2
  have hN1' : ∀ n ≥ N, dist (u n) l < ε / 2 := fun n hn => hN1 n (le_trans (le_max_left _ _) hn)
  have hN2' : ∀ n ≥ N, dist (u n) m < ε / 2 := fun n hn => hN2 n (le_trans (le_max_right _ _) hn)
  have h1' : dist (u N) l < ε / 2 := hN1' N (le_refl _)
  have h2' : dist (u N) m < ε / 2 := hN2' N (le_refl _)
  exact le_of_lt (calc
    dist l m ≤ dist l (u N) + dist (u N) m := dist_triangle _ _ _
    _ = dist (u N) l + dist (u N) m := by rw [dist_comm]
    _ < ε / 2 + ε / 2 := by linarith
    _ = ε := by ring)