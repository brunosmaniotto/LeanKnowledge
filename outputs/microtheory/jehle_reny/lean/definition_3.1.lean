import Mathlib
open Topology

noncomputable def marginalProduct {n : ℕ} (f : (Fin n → ℝ) → ℝ) (i : Fin n)
    (x : Fin n → ℝ) : ℝ :=
  fderiv ℝ f x (Pi.single i 1)

noncomputable def MRTS {n : ℕ} (f : (Fin n → ℝ) → ℝ) (i j : Fin n)
    (x : Fin n → ℝ) : ℝ :=
  marginalProduct f i x / marginalProduct f j x

def IsWeaklySeparable {n : ℕ} (f : (Fin n → ℝ) → ℝ) (S : ℕ)
    (group : Fin n → Fin S) : Prop :=
  1 < S ∧ Function.Surjective group ∧
    ∀ (s : Fin S) (i j k : Fin n), group i = s → group j = s → group k ≠ s →
      ∀ (x : Fin n → ℝ), fderiv ℝ (fun y => MRTS f i j y) x (Pi.single k 1) = 0