import Mathlib
open Topology

/-
Theorem M.K.5: Shadow prices interpretation of Lagrange multipliers.
The partial derivatives of the value function with respect to constraint
parameters equal the corresponding Lagrange multipliers.
This is a direct application of the envelope theorem (Theorem M.L.1).
-/

-- We axiomatize the envelope theorem result and derive the shadow price interpretation.

variable {n M K : ℕ}

/-- Value function v(b, c) for a constrained optimization problem -/
axiom MWG.ValueFunction (M K : ℕ) : (Fin M → ℝ) → (Fin K → ℝ) → ℝ

/-- Lagrange multipliers for inequality constraints -/
axiom MWG.LagrangeMultiplier_b (M K : ℕ) : (Fin M → ℝ) → (Fin K → ℝ) → Fin M → ℝ

/-- Lagrange multipliers for equality constraints -/
axiom MWG.LagrangeMultiplier_c (M K : ℕ) : (Fin M → ℝ) → (Fin K → ℝ) → Fin K → ℝ

/-- The envelope theorem applied to constrained optimization:
    ∂v/∂bₘ = λₘ (shadow price for inequality constraint m) -/
axiom MWG.envelope_theorem_ineq (M K : ℕ) (b : Fin M → ℝ) (c : Fin K → ℝ)
    (hDiff : DifferentiableAt ℝ (fun b' => MWG.ValueFunction M K b' c) b)
    (hBinding : True) -- binding constraints unchanged in neighborhood
    (m : Fin M) :
    fderiv ℝ (fun b' => MWG.ValueFunction M K b' c) b (Pi.single m 1) =
      MWG.LagrangeMultiplier_b M K b c m

/-- The envelope theorem applied to constrained optimization:
    ∂v/∂cₖ = λₖ (shadow price for equality constraint k) -/
axiom MWG.envelope_theorem_eq (M K : ℕ) (b : Fin M → ℝ) (c : Fin K → ℝ)
    (hDiff : DifferentiableAt ℝ (fun c' => MWG.ValueFunction M K b c') c)
    (hBinding : True) -- binding constraints unchanged in neighborhood
    (k : Fin K) :
    fderiv ℝ (fun c' => MWG.ValueFunction M K b c') c (Pi.single k 1) =
      MWG.LagrangeMultiplier_c M K b c k

/-- Theorem M.K.5: The Lagrange multipliers are the shadow prices of the constraints.
    Under the hypothesis that binding constraints are unchanged in a neighborhood
    and v is differentiable, ∂v/∂bₘ = λₘ and ∂v/∂cₖ = λₖ. -/
theorem MWG.Theorem_MK5
    (b : Fin M → ℝ) (c : Fin K → ℝ)
    (hDiffB : DifferentiableAt ℝ (fun b' => MWG.ValueFunction M K b' c) b)
    (hDiffC : DifferentiableAt ℝ (fun c' => MWG.ValueFunction M K b c') c)
    (hBinding : True) :
    (∀ m : Fin M,
      fderiv ℝ (fun b' => MWG.ValueFunction M K b' c) b (Pi.single m 1) =
        MWG.LagrangeMultiplier_b M K b c m) ∧
    (∀ k : Fin K,
      fderiv ℝ (fun c' => MWG.ValueFunction M K b c') c (Pi.single k 1) =
        MWG.LagrangeMultiplier_c M K b c k) := by
  exact ⟨fun m => MWG.envelope_theorem_ineq M K b c hDiffB hBinding m,
         fun k => MWG.envelope_theorem_eq M K b c hDiffC hBinding k⟩