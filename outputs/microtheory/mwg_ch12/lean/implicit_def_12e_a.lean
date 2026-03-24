import Mathlib

/--
A two-stage entry model.
Stage 1: All potential firms simultaneously decide 'in' or 'out'; if 'in,'
the firm pays setup cost K > 0.
Stage 2: All firms that entered play some oligopolistic game. For each
possible number of active firms, there is a unique symmetric equilibrium in
stage 2, with π_J denoting profits per firm (not including entry cost K) when
J firms enter.
-/
structure ImplicitDef12Ea where
  (K : ℝ)
  (hK : 0 < K)
  (π : ℕ → ℝ)