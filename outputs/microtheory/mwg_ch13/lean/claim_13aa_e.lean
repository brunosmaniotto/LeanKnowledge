import Mathlib
open Topology

/-- Refinement concepts for signaling games -/
inductive Refinement
  | equilibrium_dominance
  | intuitive_criterion
  | divinity
  | universal_divinity
  | D1
  | stability

/-- Whether a refinement yields a unique separating equilibrium prediction -/
axiom unique_prediction (r : Refinement) (num_types : ℕ) : Prop

/-- Eq. dominance and intuitive criterion work for two types -/
axiom ed_two : unique_prediction Refinement.equilibrium_dominance 2
axiom ic_two : unique_prediction Refinement.intuitive_criterion 2

/-- They fail for three or more types -/
axiom ed_fail (n : ℕ) (h : n ≥ 3) : ¬ unique_prediction Refinement.equilibrium_dominance n
axiom ic_fail (n : ℕ) (h : n ≥ 3) : ¬ unique_prediction Refinement.intuitive_criterion n

/-- Stronger refinements work for any number of types ≥ 2 -/
axiom div_works (n : ℕ) (h : n ≥ 2) : unique_prediction Refinement.divinity n
axiom udiv_works (n : ℕ) (h : n ≥ 2) : unique_prediction Refinement.universal_divinity n
axiom d1_works (n : ℕ) (h : n ≥ 2) : unique_prediction Refinement.D1 n
axiom stab_works (n : ℕ) (h : n ≥ 2) : unique_prediction Refinement.stability n

theorem Claim_13AA_e :
    (unique_prediction Refinement.equilibrium_dominance 2 ∧
     unique_prediction Refinement.intuitive_criterion 2) ∧
    (∀ n : ℕ, n ≥ 3 →
      ¬ unique_prediction Refinement.equilibrium_dominance n ∧
      ¬ unique_prediction Refinement.intuitive_criterion n) ∧
    (∀ n : ℕ, n ≥ 2 →
      unique_prediction Refinement.divinity n ∧
      unique_prediction Refinement.universal_divinity n ∧
      unique_prediction Refinement.D1 n ∧
      unique_prediction Refinement.stability n) :=
  ⟨⟨ed_two, ic_two⟩,
   fun n h => ⟨ed_fail n h, ic_fail n h⟩,
   fun n h => ⟨div_works n h, udiv_works n h, d1_works n h, stab_works n h⟩⟩