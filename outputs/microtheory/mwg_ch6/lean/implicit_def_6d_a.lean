import Mathlib

open MeasureTheory ProbabilityTheory

/-- A distribution `G` is a mean-preserving spread of `F` if there exists a family
    of zero-mean perturbation distributions `H` such that `G` is obtained by first
    drawing `x ~ F` then adding noise `z ~ H_x` with `𝔼[z | x] = 0`. -/
structure MeanPreservingSpread
    (F G : Measure ℝ)
    [IsProbabilityMeasure F] [IsProbabilityMeasure G] where
  /-- For each outcome x, a probability measure on the perturbation z -/
  H : ℝ → Measure ℝ
  H_prob : ∀ x, IsProbabilityMeasure (H x)
  /-- Each perturbation distribution has mean zero: ∫ z dH_x(z) = 0 -/
  zero_mean : ∀ x, ∫ z, z ∂(H x) = 0
  /-- G is the compound lottery: draw x from F, then take x + z where z ~ H_x.
      For every measurable set A, G(A) = ∫ F(dx) ∫ H_x(dz) 1_A(x+z) -/
  compound : ∀ A : Set ℝ, MeasurableSet A →
    G A = ∫⁻ x, (H x) {z | x + z ∈ A} ∂F