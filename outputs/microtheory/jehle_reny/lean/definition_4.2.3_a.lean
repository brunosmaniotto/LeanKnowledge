import Mathlib

open Set Filter Topology
open Topology

/-- Monopolistic competition market structure (Definition 4.2.3a).

A relatively large group of firms sell differentiated products that are close
but not perfect substitutes.  Each firm has limited monopoly power over its
own variant, and firms use similar technology.  Entry means introducing a
previously non-existent variant. -/
structure MonopolisticCompetition where
  /-- Type indexing the (potentially countably many) product variants -/
  Variant : Type
  /-- The set of variants currently produced by active firms -/
  activeVariants : Set Variant
  /-- Number of active firms is "relatively large" — at least 2 -/
  firms_large : Set.Finite activeVariants ∧ activeVariants.Nonempty
  /-- Cross-elasticity of substitution between any two active variants:
      positive (close substitutes) but strictly less than perfect (< 1). -/
  substitutability : Variant → Variant → ℝ
  close_substitutes :
    ∀ v w, v ∈ activeVariants → w ∈ activeVariants → v ≠ w →
      0 < substitutability v w ∧ substitutability v w < 1
  /-- Each firm's cost function for producing quantity q of its variant -/
  cost : Variant → ℝ → ℝ
  /-- Firms use similar technology: costs differ by at most factor `tech_bound` -/
  tech_bound : ℝ
  tech_bound_pos : 0 < tech_bound
  similar_technology :
    ∀ v w, v ∈ activeVariants → w ∈ activeVariants →
      ∀ q : ℝ, 0 ≤ q → cost v q ≤ tech_bound * cost w q
  /-- Entry is introducing a variant not currently active -/
  entry (v : Variant) : Prop := v ∉ activeVariants