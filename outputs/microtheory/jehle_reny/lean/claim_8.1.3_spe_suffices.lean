import Mathlib
open Topology

variable {G : Type*}

theorem insurance_screening_spe_suffices
    (Strategy : Type*)
    (IsSubgamePerfect : Strategy → Prop)
    (IsSequentialEquilibrium : Strategy → Prop)
    (Outcome : Strategy → G)
    (seq_eq_iff_spe : ∀ σ : Strategy, IsSequentialEquilibrium σ ↔ IsSubgamePerfect σ) :
    (∀ σ : Strategy, IsSequentialEquilibrium σ → IsSubgamePerfect σ) ∧
    (∀ o : G, (∃ σ, IsSequentialEquilibrium σ ∧ Outcome σ = o) ↔
              (∃ σ, IsSubgamePerfect σ ∧ Outcome σ = o)) :=
  ⟨fun σ h => (seq_eq_iff_spe σ).mp h,
   fun o => ⟨fun ⟨σ, hseq, ho⟩ => ⟨σ, (seq_eq_iff_spe σ).mp hseq, ho⟩,
             fun ⟨σ, hspe, ho⟩ => ⟨σ, (seq_eq_iff_spe σ).mpr hspe, ho⟩⟩⟩