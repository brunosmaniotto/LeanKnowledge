import Mathlib

open Filter Topology

/-- A correspondence `f : α → Set β` is lower hemicontinuous on `A` if for every
    sequence `xm → x` in `A` and every `y ∈ f x`, there exists a sequence `ym → y`
    and an integer `M` such that `ym m ∈ f (xm m)` for all `m > M`. -/
def MWG.IsLowerHemicontinuous {N K : ℕ} (A : Set (EuclideanSpace ℝ (Fin N)))
    (Y : Set (EuclideanSpace ℝ (Fin K)))
    (f : EuclideanSpace ℝ (Fin N) → Set (EuclideanSpace ℝ (Fin K))) : Prop :=
  ∀ x ∈ A,
  ∀ xm : ℕ → EuclideanSpace ℝ (Fin N),
    (∀ m, xm m ∈ A) →
    Filter.Tendsto xm Filter.atTop (nhds x) →
    ∀ y ∈ f x,
      ∃ ym : ℕ → EuclideanSpace ℝ (Fin K),
      ∃ M : ℕ,
        Filter.Tendsto ym Filter.atTop (nhds y) ∧
        ∀ m, M < m → ym m ∈ f (xm m)