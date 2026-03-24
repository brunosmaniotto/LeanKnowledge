import Mathlib
open Topology
open BigOperators

noncomputable def RadnerBudgetSet
    (S L K : ℕ)
    (p : Fin S → Fin L → ℝ)
    (q : Fin K → ℝ)
    (R : Fin S → Fin K → ℝ)
    (ω : Fin S → Fin L → ℝ) :
    Set (Fin S → Fin L → ℝ) :=
  {x | (∀ s l, 0 ≤ x s l) ∧
       ∃ z : Fin K → ℝ,
         (∑ k, q k * z k) ≤ 0 ∧
         (∀ s : Fin S,
           (∑ l, p s l * (x s l - ω s l)) = ∑ k, R s k * z k)}