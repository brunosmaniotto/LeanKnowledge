import Mathlib

open Filter
open scoped Topology

theorem Convergent_Sequence_Minus_Limit {X : Type} [NormedAddCommGroup X] {x : ℕ → X} {l : X}
    (hx : Tendsto x atTop (𝓝 l)) : Tendsto (fun n => ‖x n - l‖) atTop (𝓝 0) := by
  have h_const : Tendsto (fun _ : ℕ => l) atTop (𝓝 l) := tendsto_const_nhds
  have h_sub : Tendsto (fun n => x n - l) atTop (𝓝 (l - l)) := Tendsto.sub hx h_const
  have h_sub0 : Tendsto (fun n => x n - l) atTop (𝓝 0) := by
    simpa [sub_self] using h_sub
  have h_norm : Tendsto (fun n => ‖x n - l‖) atTop (𝓝 (‖(0 : X)‖)) := Tendsto.norm h_sub0
  simpa [norm_zero] using h_norm