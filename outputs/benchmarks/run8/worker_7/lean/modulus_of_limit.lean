import Mathlib
open Filter Topology

theorem modulus_of_limit {X : Type} [NormedAddCommGroup X] {x : ℕ → X} {l : X}
    (h : Tendsto x atTop (𝓝 l)) : Tendsto (λ n => ‖x n‖) atTop (𝓝 ‖l‖) :=
  h.norm