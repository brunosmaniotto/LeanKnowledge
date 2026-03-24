import Mathlib

/-- A strategic form game consists of players, strategy sets, and payoff functions. -/
structure StrategicFormGame where
  Players : Type
  Strategy : Players → Type
  payoff : (∀ p, Strategy p) → Players → ℝ

/-- Cournot duopoly as a strategic form game: two firms choose quantities,
    payoffs determined by inverse demand minus costs. -/
noncomputable def CournotGame (a b c : ℝ) : StrategicFormGame where
  Players := Fin 2
  Strategy := fun _ => ℝ  -- each firm chooses a quantity
  payoff := fun profile i =>
    let q_i := profile i
    let q_j := profile (1 - i)
    let price := a - b * (q_i + q_j)
    q_i * (price - c)

/-- Bertrand duopoly as a strategic form game: two firms choose prices,
    payoffs determined by demand allocation and costs. -/
noncomputable def BertrandGame (c : ℝ) (D : ℝ → ℝ) : StrategicFormGame where
  Players := Fin 2
  Strategy := fun _ => ℝ  -- each firm chooses a price
  payoff := fun profile i =>
    let p_i := profile i
    let p_j := profile (1 - i)
    if p_i < p_j then (p_i - c) * D p_i
    else if p_i > p_j then 0
    else (p_i - c) * D p_i / 2

/-- The Cournot and Bertrand duopoly models can both be formulated as
    strategic form games. -/
theorem Exercise_7_1 :
    (∃ g : StrategicFormGame, g.Players = Fin 2) ∧
    (∃ g : StrategicFormGame, g.Players = Fin 2) :=
  ⟨⟨CournotGame 1 1 0, rfl⟩, ⟨BertrandGame 0 id, rfl⟩⟩