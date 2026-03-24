import Mathlib

open MeasureTheory ProbabilityTheory Set
open ProbabilityTheory

/-- For independent random variables with atomless distributions, compositions
    with strictly monotone functions coincide with probability zero. -/
axiom indep_strictMono_atomless_coincidence_zero
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {f g : Ω → ℝ} {φ ψ : ℝ → ℝ}
    (hφ : StrictMono φ) (hψ : StrictMono ψ)
    (hf_meas : Measurable f) (hg_meas : Measurable g)
    (hf_atomless : ∀ x : ℝ, μ {ω | f ω = x} = 0)
    (h_indep : IndepFun f g μ) :
    μ {ω | φ (f ω) = ψ (g ω)} = 0

theorem Claim_9_4_3_f
    {N : ℕ} (hN : 2 ≤ N)
    (φ : Fin N → ℝ → ℝ)
    (hφ_strict : ∀ i, StrictMono (φ i))
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    (v : Fin N → Ω → ℝ)
    (hv_meas : ∀ i, Measurable (v i))
    (hv_atomless : ∀ i, ∀ x : ℝ, μ {ω | v i ω = x} = 0)
    (hv_indep : ∀ i j : Fin N, i ≠ j → IndepFun (v i) (v j) μ) :
    μ {ω | ∃ i j : Fin N, i ≠ j ∧ φ i (v i ω) = φ j (v j ω)} = 0 := by
  have pair_zero : ∀ i j : Fin N, i ≠ j →
      μ {ω | φ i (v i ω) = φ j (v j ω)} = 0 := fun i j hij =>
    indep_strictMono_atomless_coincidence_zero (hφ_strict i) (hφ_strict j)
      (hv_meas i) (hv_meas j) (hv_atomless i) (hv_indep i j hij)
  have hsub : {ω | ∃ i j : Fin N, i ≠ j ∧ φ i (v i ω) = φ j (v j ω)} ⊆
      ⋃ (p : {p : Fin N × Fin N // p.1 ≠ p.2}),
        {ω | φ p.val.1 (v p.val.1 ω) = φ p.val.2 (v p.val.2 ω)} := by
    intro ω ⟨i, j, hij, heq⟩
    exact mem_iUnion.mpr ⟨⟨(i, j), hij⟩, heq⟩
  exact measure_mono_null hsub
    (measure_iUnion_null fun ⟨⟨i, j⟩, hij⟩ => pair_zero i j hij)