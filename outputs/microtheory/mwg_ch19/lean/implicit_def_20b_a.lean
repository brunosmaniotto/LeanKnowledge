import Mathlib

open BigOperators
open Finset

/-- An intertemporal consumption model with infinitely many dates t = 0, 1, ...
    Objects of choice are bounded consumption streams c = (c₀, c₁, ...) where cₜ ∈ ℝ^L₊.
    Preferences are represented by V(c) = Σ_{t=0}^∞ δ^t u(cₜ). -/
structure IntertemporalUtilityModel where
  /-- Number of goods -/
  numGoods : ℕ
  /-- Discount factor -/
  δ : ℝ
  /-- Per-period utility function on ℝ^L₊ -/
  u : (Fin numGoods → ℝ) → ℝ
  /-- Discount factor is positive -/
  δ_pos : 0 < δ
  /-- Discount factor is strictly less than 1 -/
  δ_lt_one : δ < 1
  /-- u is strictly increasing (monotone) on the nonneg orthant -/
  u_strictMono : StrictMono u
  /-- u is concave -/
  u_concave : ConcaveOn ℝ Set.univ u

namespace IntertemporalUtilityModel

/-- A consumption stream: a sequence of consumption bundles in ℝ^L₊ -/
def ConsumptionStream (M : IntertemporalUtilityModel) :=
  ℕ → (Fin M.numGoods → ℝ)

/-- The discounted utility of a finite truncation up to T periods:
    V_T(c) = Σ_{t=0}^{T-1} δ^t u(cₜ) -/
noncomputable def discountedUtilityFinite (M : IntertemporalUtilityModel)
    (c : M.ConsumptionStream) (T : ℕ) : ℝ :=
  ∑ t ∈ Finset.range T, M.δ ^ t * M.u (c t)

/-- The discounted utility of an infinite consumption stream:
    V(c) = Σ_{t=0}^∞ δ^t u(cₜ) -/
noncomputable def discountedUtility (M : IntertemporalUtilityModel)
    (c : M.ConsumptionStream) : ℝ :=
  ∑' t, M.δ ^ t * M.u (c t)

end IntertemporalUtilityModel