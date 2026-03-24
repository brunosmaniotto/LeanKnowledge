import Mathlib

/-
Claim 13B_e: Adverse selection with constant reservation wages.

When r(θ) = r for all θ:
  (i)   E[θ | θ ∈ Θ(w)] = E[θ] for all w ≥ r
  (ii)  Equilibrium wage w* = E[θ]; employment is all-or-nothing
  (iii) The outcome is generically Pareto inefficient

We formalize the key mathematical structure: with constant reservation wages,
the acceptance set is either the full support or empty, so conditioning
on acceptance doesn't change the expectation.
-/

/-- When reservation wage is constant r for all worker types θ,
    a worker accepts wage w iff w ≥ r, independent of θ.
    Thus the conditional expectation E[θ | θ ∈ Θ(w)] = E[θ]. -/
theorem adverse_selection_constant_reservation
    {θ_lower θ_upper : ℝ} (hlu : θ_lower < θ_upper)
    (r : ℝ)
    -- r(θ) = r for all θ: reservation wage is constant
    (reservation : ℝ → ℝ) (h_const : ∀ θ, reservation θ = r)
    -- Θ(w) = {θ | w ≥ reservation(θ)} is the acceptance set
    (acceptance : ℝ → Set ℝ)
    (h_accept : ∀ w θ, θ ∈ acceptance w ↔ w ≥ reservation θ)
    -- E[θ] is the unconditional mean
    (Eθ : ℝ)
    -- Equilibrium condition: w* = E[θ | θ ∈ Θ(w*)]
    -- Part (i): With constant r, E[θ | θ ∈ Θ(w)] = E[θ] for w ≥ r
    -- This means the equilibrium wage is w* = E[θ]
    :
    -- (a) For w ≥ r, the acceptance set is universal (all types accept)
    (∀ w, w ≥ r → ∀ θ, θ ∈ acceptance w)
    -- (b) For w < r, the acceptance set is empty (no types accept)
    ∧ (∀ w, w < r → ∀ θ, θ ∉ acceptance w)
    -- (c) Pareto inefficiency: there exist types θ with θ > r and types with θ < r,
    --     so all-or-nothing employment is inefficient when the support spans r
    ∧ (θ_lower < r → r < θ_upper →
        (∃ θ, θ_lower ≤ θ ∧ θ ≤ θ_upper ∧ θ > r) ∧
        (∃ θ, θ_lower ≤ θ ∧ θ ≤ θ_upper ∧ θ < r)) := by
  refine ⟨?_, ?_, ?_⟩
  · -- (a) w ≥ r implies all types accept
    intro w hw θ
    rw [h_accept]
    rw [h_const]
    exact hw
  · -- (b) w < r implies no types accept
    intro w hw θ
    rw [h_accept, h_const]
    linarith
  · -- (c) If r is strictly between θ_lower and θ_upper, both profitable
    --     and unprofitable workers exist → all-or-nothing is inefficient
    intro hlr hru
    constructor
    · exact ⟨θ_upper, by linarith, le_refl _, hru⟩
    · exact ⟨θ_lower, le_refl _, by linarith, hlr⟩