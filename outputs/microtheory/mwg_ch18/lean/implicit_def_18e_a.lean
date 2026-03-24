import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A quasilinear exchange economy with H consumer types and L goods,
    where good L is the numeraire. -/
structure QuasilinearEconomy (H : ℕ) (L : ℕ) where
  /-- Concave utility component for each type h, over the first (L-1) goods -/
  ψ : Fin H → (Fin (L - 1) → ℝ) → ℝ
  /-- Number of consumers of each type -/
  I : Fin H → ℕ
  /-- ψ_h is strictly concave for each type -/
  ψ_strictly_concave : ∀ h : Fin H, StrictConcaveOn ℝ (Set.univ) (ψ h)

namespace QuasilinearEconomy

/-- The utility function for type h: u_h(x_h) = ψ_h(x_{1h},...,x_{(L-1)h}) + x_{Lh} -/
noncomputable def utility {H L : ℕ} (E : QuasilinearEconomy H L)
    (h : Fin H) (x : Fin (L - 1) → ℝ) (xL : ℝ) : ℝ :=
  E.ψ h x + xL

/-- Grand total number of consumers: I = Σ_h I_h -/
noncomputable def totalConsumers {H L : ℕ} (E : QuasilinearEconomy H L) : ℕ :=
  ∑ h : Fin H, E.I h

end QuasilinearEconomy