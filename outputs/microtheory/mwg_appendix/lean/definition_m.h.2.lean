import Mathlib

open Filter Topology

/-- A correspondence f : A → Set Y has a closed graph if for any sequences
    xₘ → x ∈ A and yₘ → y with xₘ ∈ A and yₘ ∈ f(xₘ), we have y ∈ f(x). -/
def MWG.HasClosedGraph {N K : ℕ} (A : Set (EuclideanSpace ℝ (Fin N)))
    (Y : Set (EuclideanSpace ℝ (Fin K))) (f : EuclideanSpace ℝ (Fin N) → Set (EuclideanSpace ℝ (Fin K))) : Prop :=
  ∀ (x : EuclideanSpace ℝ (Fin N)) (xSeq : ℕ → EuclideanSpace ℝ (Fin N))
    (ySeq : ℕ → EuclideanSpace ℝ (Fin K)) (y : EuclideanSpace ℝ (Fin K)),
    x ∈ A →
    (∀ m, xSeq m ∈ A) →
    (∀ m, ySeq m ∈ f (xSeq m)) →
    Filter.Tendsto xSeq atTop (nhds x) →
    Filter.Tendsto ySeq atTop (nhds y) →
    y ∈ f x