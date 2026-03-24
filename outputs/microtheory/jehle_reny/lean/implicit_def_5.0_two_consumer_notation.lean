import Mathlib
open Topology

/-- Two-consumer, two-good endowment economy (MWG p.213).
    Consumer i has endowment vector eᵢ : Fin 2 → ℝ over two goods.
    Superscripts denote consumers, subscripts denote goods. -/
structure TwoConsumerEndowment where
  /-- Consumer 1's endowment vector (e¹₁, e¹₂) -/
  e₁ : Fin 2 → ℝ
  /-- Consumer 2's endowment vector (e²₁, e²₂) -/
  e₂ : Fin 2 → ℝ

/-- Total endowment: component-wise sum e₁ + e₂ = (e¹₁ + e²₁, e¹₂ + e²₂). -/
def TwoConsumerEndowment.total (eco : TwoConsumerEndowment) : Fin 2 → ℝ :=
  eco.e₁ + eco.e₂