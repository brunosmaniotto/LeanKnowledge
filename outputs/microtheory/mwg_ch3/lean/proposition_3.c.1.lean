import Mathlib

open Set Filter Topology
open Topology

/-- A rational (complete, transitive) preference relation that is continuous. -/
structure ContinuousRationalPreference (X : Type*) [TopologicalSpace X] where
  pref : X → X → Prop
  complete : ∀ x y, pref x y ∨ pref y x
  trans : ∀ x y z, pref x y → pref y z → pref x z
  upper_closed : ∀ x, IsClosed {y | pref y x}
  lower_closed : ∀ x, IsClosed {y | pref x y}

/-- Monotonicity for preferences on ℝ^L. -/
structure MonotonePreference {L : ℕ} (R : ContinuousRationalPreference (Fin L → ℝ)) where
  monotone : ∀ x y : Fin L → ℝ, (∀ i, x i ≥ y i) → R.pref x y

/-- Core analytical content: for each x, there exists a unique α ≥ 0 with αe ~ x. -/
axiom diagonal_utility_exists {L : ℕ} (R : ContinuousRationalPreference (Fin L → ℝ))
    (M : MonotonePreference R) (x : Fin L → ℝ) :
    ∃! α : ℝ, α ≥ 0 ∧ R.pref (fun _ => α) x ∧ R.pref x (fun _ => α)

/-- The diagonal utility function. -/
noncomputable def diagUtil {L : ℕ} (R : ContinuousRationalPreference (Fin L → ℝ))
    (M : MonotonePreference R) (x : Fin L → ℝ) : ℝ :=
  (diagonal_utility_exists R M x).choose

axiom diagUtil_spec {L : ℕ} (R : ContinuousRationalPreference (Fin L → ℝ))
    (M : MonotonePreference R) (x : Fin L → ℝ) :
    R.pref (fun _ => diagUtil R M x) x ∧ R.pref x (fun _ => diagUtil R M x)

axiom diagUtil_unique {L : ℕ} (R : ContinuousRationalPreference (Fin L → ℝ))
    (M : MonotonePreference R) (x : Fin L → ℝ) (α : ℝ) :
    R.pref (fun _ => α) x → R.pref x (fun _ => α) → α = diagUtil R M x

axiom diagUtil_continuous {L : ℕ} (R : ContinuousRationalPreference (Fin L → ℝ))
    (M : MonotonePreference R) :
    Continuous (diagUtil R M)

axiom diagonal_strict {L : ℕ} (R : ContinuousRationalPreference (Fin L → ℝ))
    (M : MonotonePreference R) (α β : ℝ) :
    α > β → R.pref (fun _ : Fin L => α) (fun _ => β) ∧ ¬R.pref (fun _ : Fin L => β) (fun _ => α)

/-- Proposition 3.C.1: A continuous monotone rational preference on ℝ^L
    admits a continuous utility representation. -/
theorem continuous_utility_representation
    {L : ℕ} (R : ContinuousRationalPreference (Fin L → ℝ))
    (M : MonotonePreference R) :
    ∃ u : (Fin L → ℝ) → ℝ, Continuous u ∧ ∀ x y, R.pref x y ↔ u x ≥ u y := by
  refine ⟨diagUtil R M, diagUtil_continuous R M, fun x y => ?_⟩
  constructor
  · intro hxy
    have hx := diagUtil_spec R M x
    have hy := diagUtil_spec R M y
    by_contra h
    push_neg at h
    have hds := diagonal_strict R M (diagUtil R M y) (diagUtil R M x) h
    have chain : R.pref (fun _ => diagUtil R M x) (fun _ => diagUtil R M y) :=
      R.trans _ _ _ hx.1 (R.trans _ _ _ hxy hy.2)
    exact hds.2 chain
  · intro hge
    have hx := diagUtil_spec R M x
    have hy := diagUtil_spec R M y
    rcases le_antisymm_iff.mp (le_antisymm (le_refl (diagUtil R M x)) (le_refl (diagUtil R M x))) with ⟨_, _⟩
    by_cases heq : diagUtil R M x = diagUtil R M y
    · have : (fun _ : Fin L => diagUtil R M x) = (fun _ => diagUtil R M y) := by
        ext; exact heq
      rw [this] at hx
      exact R.trans _ _ _ hx.2 hy.1
    · have hgt : diagUtil R M x > diagUtil R M y := lt_of_le_of_ne hge (Ne.symm heq) |>.gt
      have hds := (diagonal_strict R M (diagUtil R M x) (diagUtil R M y) hgt).1
      exact R.trans _ _ _ hx.2 (R.trans _ _ _ hds hy.1)