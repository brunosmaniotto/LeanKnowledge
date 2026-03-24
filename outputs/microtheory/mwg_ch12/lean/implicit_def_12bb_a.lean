import Mathlib
open Topology

/-- Three-stage entry deterrence game (Spence 1977, Dixit 1980).
  Stage 1: Incumbent chooses capacity k_I at cost r per unit.
  Stage 2: Entrant decides whether to enter (paying cost F).
  Stage 3: If entry, simultaneous output choice; otherwise incumbent is monopolist. -/
structure EntryDeterrenceGame where
  /-- Per-unit capacity cost (sunk in Stage 1) -/
  r : ℝ
  /-- Per-unit variable production cost -/
  w : ℝ
  /-- Fixed entry cost for firm E -/
  F : ℝ
  /-- Inverse demand function: price as a function of total quantity -/
  inverseDemand : ℝ → ℝ
  /-- Incumbent's capacity choice (Stage 1) -/
  k_I : ℝ
  hr_pos : 0 < r
  hw_pos : 0 < w
  hF_pos : 0 < F

namespace EntryDeterrenceGame

/-- Incumbent's profit when entry occurs: produces q_I ≤ k_I at variable cost w
    (capacity cost already sunk) -/
noncomputable def incumbentProfitEntry (G : EntryDeterrenceGame) (q_I q_E : ℝ) : ℝ :=
  G.inverseDemand (q_I + q_E) * q_I - G.w * q_I

/-- Entrant's profit: pays both variable cost w and capacity cost r per unit, plus fixed cost F -/
noncomputable def entrantProfit (G : EntryDeterrenceGame) (q_I q_E : ℝ) : ℝ :=
  G.inverseDemand (q_I + q_E) * q_E - (G.w + G.r) * q_E - G.F

/-- Incumbent's monopoly profit when no entry occurs: produces q_I ≤ k_I at variable cost w -/
noncomputable def incumbentProfitMonopoly (G : EntryDeterrenceGame) (q_I : ℝ) : ℝ :=
  G.inverseDemand q_I * q_I - G.w * q_I

/-- Total incumbent payoff including sunk capacity cost from Stage 1 -/
noncomputable def incumbentTotalPayoffEntry (G : EntryDeterrenceGame) (q_I q_E : ℝ) : ℝ :=
  G.incumbentProfitEntry q_I q_E - G.r * G.k_I

/-- Total incumbent payoff as monopolist including sunk capacity cost -/
noncomputable def incumbentTotalPayoffMonopoly (G : EntryDeterrenceGame) (q_I : ℝ) : ℝ :=
  G.incumbentProfitMonopoly q_I - G.r * G.k_I

/-- Entrant enters iff post-entry profit is non-negative -/
noncomputable def entryCondition (G : EntryDeterrenceGame) (q_I q_E : ℝ) : Prop :=
  G.entrantProfit q_I q_E ≥ 0

/-- Output constraint: incumbent cannot produce more than installed capacity -/
def capacityConstraint (G : EntryDeterrenceGame) (q_I : ℝ) : Prop :=
  q_I ≤ G.k_I

end EntryDeterrenceGame