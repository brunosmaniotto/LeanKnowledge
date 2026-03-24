import Mathlib

structure PreferenceProfile (I : ℕ) (A : Type*) where
  prefers : Fin I → A → A → Prop

structure SCF (I : ℕ) (A : Type*) where
  f : PreferenceProfile I A → A

def Monotonic {I : ℕ} {A : Type*} (scf : SCF I A) : Prop :=
  ∀ θ θ' : PreferenceProfile I A,
    (∀ i b, θ.prefers i (scf.f θ) b → θ'.prefers i (scf.f θ) b) →
    scf.f θ' = scf.f θ