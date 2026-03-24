import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The marginal contribution of type `h` given a profile `I'`. -/
noncomputable def marginal_contribution
    (v : (Fin H → ℕ) → ℝ) (h : Fin H) (I' : Fin H → ℕ) : ℝ :=
  v I' - v (Function.update I' h (I' h - 1))

/-- The probability weight on profile `I'` when independently sampling
    consumers from the original population with profile `I`. -/
noncomputable def shapley_weight
    (I I' : Fin H → ℕ) : ℝ :=
  let I_total := ∑ h, I h
  if I_total = 0 then 0
  else
    (1 / (I_total : ℝ)) *
    (∏ h : Fin H, (Nat.choose (I h) (I' h) : ℝ)) *
    ((Nat.factorial (∑ h, I' h - 1) * Nat.factorial (I_total - ∑ h, I' h) : ℕ) : ℝ) /
    (Nat.factorial I_total : ℝ)

/-- The Shapley value for type `h`: weighted average of marginal contributions
    over all subprofiles `I' ≤ I`. We enumerate over the finite product type
    `Fin H → Fin (max_val + 1)` and filter to profiles bounded by `I`. -/
noncomputable def shapley_value
    (H : ℕ) (v : (Fin H → ℕ) → ℝ) (I : Fin H → ℕ) (h : Fin H) : ℝ :=
  let bound := Finset.univ.sup I + 1
  ∑ I' : Fin H → Fin bound,
    let I'_nat : Fin H → ℕ := fun i => (I' i : ℕ)
    if ∀ i, I'_nat i ≤ I i then
      shapley_weight I I'_nat * marginal_contribution v h I'_nat
    else 0

/-- The Shapley value satisfies the efficiency axiom:
    the total value is distributed among all consumers. -/
noncomputable def shapley_value_vector
    (H : ℕ) (v : (Fin H → ℕ) → ℝ) (I : Fin H → ℕ) : Fin H → ℝ :=
  fun h => shapley_value H v I h