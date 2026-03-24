import Mathlib

open BigOperators
open Topology

/-- An infinitely repeated game with two players. -/
structure InfinitelyRepeatedGame where
  S₀ : Type
  S₁ : Type
  π : Fin 2 → S₀ → S₁ → ℝ
  δ : ℝ
  hδ_pos : 0 < δ
  hδ_lt : δ < 1
  nashEq₀ : S₀
  nashEq₁ : S₁
  nash_opt_0 : ∀ a : S₀, π 0 nashEq₀ nashEq₁ ≥ π 0 a nashEq₁
  nash_opt_1 : ∀ a : S₁, π 1 nashEq₀ nashEq₁ ≥ π 1 nashEq₀ a

namespace InfinitelyRepeatedGame
variable (G : InfinitelyRepeatedGame)

/-- Outcome path: infinite sequence of action profiles. -/
abbrev OutcomePath := ℕ → G.S₀ × G.S₁

/-- Pure strategy for player 0: maps period and history to action. -/
abbrev PureStrategy₀ := (t : ℕ) → (Fin t → G.S₀ × G.S₁) → G.S₀

/-- Pure strategy for player 1. -/
abbrev PureStrategy₁ := (t : ℕ) → (Fin t → G.S₀ × G.S₁) → G.S₁

/-- Discounted payoff: v_i(Q) = Σ_{t≥0} δ^t · π_i(q_t). -/
noncomputable def discountedPayoff (i : Fin 2) (Q : G.OutcomePath) : ℝ :=
  ∑' (t : ℕ), G.δ ^ t * G.π i (Q t).1 (Q t).2

/-- Average payoff: (1-δ) · v_i(Q). -/
noncomputable def averagePayoff (i : Fin 2) (Q : G.OutcomePath) : ℝ :=
  (1 - G.δ) * G.discountedPayoff i Q

/-- Continuation payoff from period t: v_i(Q,t) = Σ_{s≥0} δ^s · π_i(q_{t+s}). -/
noncomputable def continuationPayoff (i : Fin 2) (Q : G.OutcomePath) (t : ℕ) : ℝ :=
  ∑' (s : ℕ), G.δ ^ s * G.π i (Q (t + s)).1 (Q (t + s)).2

end InfinitelyRepeatedGame