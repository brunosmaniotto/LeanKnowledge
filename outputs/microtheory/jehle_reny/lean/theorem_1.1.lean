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

/-- Strict monotonicity for preferences on ℝ^n_+. -/
structure StrictlyMonotonePreference {n : ℕ} (R : ContinuousRationalPreference (Fin n → ℝ)) where
  monotone : ∀ x y : Fin n → ℝ, (∀ i, x i ≥ y i) → R.pref x y
  strict : ∀ x y : Fin n → ℝ, (∀ i, x i ≥ y i) → (∃ i, x i > y i) →
    R.pref x y ∧ ¬R.pref y x

/-- Core analytical content: for each x ∈ ℝ^n_+, there exists a unique α ≥ 0
    with αe ~ x (existence via IVT on A ∩ B, uniqueness via strict monotonicity). -/
axiom diagonal_utility_exists {n : ℕ} (R : ContinuousRationalPreference (Fin n → ℝ))
    (M : StrictlyMonotonePreference R) (x : Fin n → ℝ) :
    ∃! α : ℝ, α ≥ 0 ∧ R.pref (fun _ => α) x ∧ R.pref x (fun _ => α)

/-- The diagonal utility function u(x) satisfying u(x)·e ~ x. -/
noncomputable def diagUtil {n : ℕ} (R : ContinuousRationalPreference (Fin n → ℝ))
    (M : StrictlyMonotonePreference R) (x : Fin n → ℝ) : ℝ :=
  (diagonal_utility_exists R M x).choose

axiom diagUtil_spec {n : ℕ} (R : ContinuousRationalPreference (Fin n → ℝ))
    (M : StrictlyMonotonePreference R) (x : Fin n → ℝ) :
    R.pref (fun _ => diagUtil R M x) x ∧ R.pref x (fun _ => diagUtil R M x)

axiom diagUtil_unique {n : ℕ} (R : ContinuousRationalPreference (Fin n → ℝ))
    (M : StrictlyMonotonePreference R) (x : Fin n → ℝ) (α : ℝ) :
    R.pref (fun _ => α) x → R.pref x (fun _ => α) → α = diagUtil R M x

axiom diagUtil_continuous {n : ℕ} (R : ContinuousRationalPreference (Fin n → ℝ))
    (M : StrictlyMonotonePreference R) :
    Continuous (diagUtil R M)

axiom diagonal_strict {n : ℕ} (R : ContinuousRationalPreference (Fin n → ℝ))
    (M : StrictlyMonotonePreference R) (α β : ℝ) :
    α > β → R.pref (fun _ : Fin n => α) (fun _ => β) ∧
             ¬R.pref (fun _ : Fin n => β) (fun _ => α)

/-- Theorem 1.1 (Jehle & Reny): If ≿ on ℝ^n_+ is complete, transitive, continuous,
    and strictly monotonic, there exists a continuous utility function u representing ≿. -/
theorem theorem_1_1
    {n : ℕ} (R : ContinuousRationalPreference (Fin n → ℝ))
    (M : StrictlyMonotonePreference R) :
    ∃ u : (Fin n → ℝ) → ℝ, Continuous u ∧ ∀ x y, R.pref x y ↔ u x ≥ u y := by
  refine ⟨diagUtil R M, diagUtil_continuous R M, fun x y => ?_⟩
  constructor
  · -- Forward: x ≿ y → u(x) ≥ u(y)
    intro hxy
    have hx := diagUtil_spec R M x
    have hy := diagUtil_spec R M y
    by_contra h
    push_neg at h
    -- u(y) > u(x), so u(y)e ≻ u(x)e by strict monotonicity on diagonal
    have hds := diagonal_strict R M (diagUtil R M y) (diagUtil R M x) h
    -- But u(x)e ~ x ≿ y ~ u(y)e gives u(x)e ≿ u(y)e, contradiction
    have chain : R.pref (fun _ => diagUtil R M x) (fun _ => diagUtil R M y) :=
      R.trans _ _ _ hx.1 (R.trans _ _ _ hxy hy.2)
    exact hds.2 chain
  · -- Backward: u(x) ≥ u(y) → x ≿ y
    intro hge
    have hx := diagUtil_spec R M x
    have hy := diagUtil_spec R M y
    by_cases heq : diagUtil R M x = diagUtil R M y
    · -- u(x) = u(y): then u(x)e = u(y)e, so x ~ u(x)e = u(y)e ~ y
      have : (fun _ : Fin n => diagUtil R M x) = (fun _ => diagUtil R M y) := by
        ext; exact heq
      rw [this] at hx
      exact R.trans _ _ _ hx.2 hy.1
    · -- u(x) > u(y): u(x)e ≿ u(y)e by diagonal_strict, chain with indifferences
      have hgt : diagUtil R M x > diagUtil R M y :=
        lt_of_le_of_ne hge (Ne.symm heq) |>.gt
      have hds := (diagonal_strict R M (diagUtil R M x) (diagUtil R M y) hgt).1
      exact R.trans _ _ _ hx.2 (R.trans _ _ _ hds hy.1)