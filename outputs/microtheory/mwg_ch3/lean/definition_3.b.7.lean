import Mathlib

/-- The standard basis vector e₁ = (1, 0, ..., 0) in ℝ^L.
    Defined as the function that is 1 at index 0 and 0 elsewhere. -/
noncomputable def e₁ {L : ℕ} (hL : 0 < L) : Fin L → ℝ :=
  Pi.single ⟨0, hL⟩ 1

/-- The consumption set X = (-∞, ∞) × ℝ₊^{L-1}: no lower bound on commodity 1,
    non-negative for all other commodities. -/
def QuasilinearConsumptionSet {L : ℕ} (hL : 0 < L) : Set (Fin L → ℝ) :=
  {x | ∀ i : Fin L, i ≠ ⟨0, hL⟩ → 0 ≤ x i}

/-- A preference relation ≿ on X = (-∞,∞) × ℝ₊^{L-1} is **quasilinear with respect to
    commodity 1** (the numeraire) if:
    (i)  Indifference sets are parallel displacements along e₁:
         x ~ y → (x + αe₁) ~ (y + αe₁) for all α ∈ ℝ.
    (ii) Good 1 is desirable: x + αe₁ ≻ x for all x and all α > 0.
    Here `pref x y` means x ≿ y (weak preference). Indifference x ~ y is encoded
    as `pref x y ∧ pref y x`, and strict preference x ≻ y as `pref x y ∧ ¬pref y x`.
    (MWG Definition 3.B.7) -/
structure IsQuasilinear {L : ℕ} (hL : 0 < L)
    (pref : (Fin L → ℝ) → (Fin L → ℝ) → Prop) : Prop where
  /-- Parallel displacement of indifference sets along e₁ -/
  parallel_shift : ∀ x y : Fin L → ℝ, ∀ α : ℝ,
    pref x y → pref y x →
    pref (x + α • e₁ hL) (y + α • e₁ hL) ∧ pref (y + α • e₁ hL) (x + α • e₁ hL)
  /-- The numeraire commodity is desirable: x + αe₁ ≻ x for α > 0 -/
  numeraire_desirable : ∀ x : Fin L → ℝ, ∀ α : ℝ, 0 < α →
    pref (x + α • e₁ hL) x ∧ ¬pref x (x + α • e₁ hL)