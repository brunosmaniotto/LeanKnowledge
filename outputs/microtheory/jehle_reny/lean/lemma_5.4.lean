import Mathlib

-- Axiomatize the economic structures
axiom WEA : {I : Type} → {L : Type} → (I → Fin r → (L → ℝ)) → Prop
axiom Core : {I : Type} → {L : Type} → (I → Fin r → (L → ℝ)) → Prop
axiom EqualTreatment : {I : Type} → {L : Type} → (I → Fin r → (L → ℝ)) → Prop

axiom WEA_E1 : {I : Type} → {L : Type} → (I → (L → ℝ)) → Prop

noncomputable section

variable {I : Type} {L : Type} {r : ℕ}

/-- An allocation is an r-fold replica of an E₁ allocation -/
def IsReplicaOf (x : I → Fin r → (L → ℝ)) (y : I → (L → ℝ)) : Prop :=
  ∀ i, ∀ j : Fin r, x i j = y i

/-- Theorem 5.5: WEA implies core membership -/
axiom wea_implies_core : ∀ (x : I → Fin r → (L → ℝ)), WEA x → Core x

/-- Theorem 5.16: Core of replica economy satisfies equal treatment -/
axiom core_implies_equal_treatment :
  ∀ (x : I → Fin r → (L → ℝ)), Core x → EqualTreatment x

/-- Equal treatment means the allocation is a replica of some E₁ allocation -/
axiom equal_treatment_gives_replica :
  ∀ (x : I → Fin r → (L → ℝ)), EqualTreatment x →
    ∃ y : I → (L → ℝ), IsReplicaOf x y

/-- A replica of a WEA₁ allocation is a WEA in Eᵣ -/
axiom replica_of_wea1_is_wea :
  ∀ (y : I → (L → ℝ)) (x : I → Fin r → (L → ℝ)),
    WEA_E1 y → IsReplicaOf x y → WEA x

/-- The compressed allocation from a WEA replica is a WEA in E₁ -/
axiom wea_replica_implies_wea1 :
  ∀ (x : I → Fin r → (L → ℝ)) (y : I → (L → ℝ)),
    WEA x → IsReplicaOf x y → WEA_E1 y