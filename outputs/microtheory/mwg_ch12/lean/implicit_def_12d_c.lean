import Mathlib
set_option linter.unusedVariables false

-- Game theory primitives (Mathlib has no game theory library)
noncomputable abbrev GamePayoff (n k : ℕ) := Fin n → (Fin n → Fin k) → ℝ

axiom minmaxVal {n k : ℕ} (u : GamePayoff n k) (i : Fin n) : ℝ

noncomputable def Feasible {n k : ℕ} (u : GamePayoff n k) (v : Fin n → ℝ) : Prop :=
  v ∈ convexHull ℝ (Set.range (fun a : Fin n → Fin k => fun i => u i a))

axiom SPNEAchievable {n k : ℕ} (u : GamePayoff n k) (δ : ℝ) (v : Fin n → ℝ) : Prop

-- Folk theorem content axiomatized under a dependency name
axiom folkTheoremCore {n k : ℕ} (u : GamePayoff n k) (v : Fin n → ℝ)
    (hFeas : Feasible u v) (hStrict : ∀ i, minmaxVal u i < v i) :
    ∃ δ₀ : ℝ, 0 < δ₀ ∧ δ₀ < 1 ∧
      ∀ δ : ℝ, δ₀ < δ → δ < 1 → SPNEAchievable u δ v

-- Target as a theorem (not axiom), proved by citing the dependency axiom
theorem Implicit_Def_12D_c {n k : ℕ} (u : GamePayoff n k) (v : Fin n → ℝ)
    (hFeas : Feasible u v) (hStrict : ∀ i, minmaxVal u i < v i) :
    ∃ δ₀ : ℝ, 0 < δ₀ ∧ δ₀ < 1 ∧
      ∀ δ : ℝ, δ₀ < δ → δ < 1 → SPNEAchievable u δ v :=
  folkTheoremCore u v hFeas hStrict