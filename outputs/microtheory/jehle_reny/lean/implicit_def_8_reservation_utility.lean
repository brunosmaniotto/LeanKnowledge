import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The consumer's reservation utility ū satisfies the participation constraint:
    ū ≥ max_{e ∈ {0,1}} [Σ_{l=0}^{L} π_l(e) · u(w − l) − d(e)],
    ensuring ū is at least the best expected utility achievable without insurance.
    This holds because the consumer can always choose not to purchase insurance,
    and may be strictly larger if other insurers offer policies. -/
def ReservationUtilityBound (L : ℕ) (π : Fin 2 → Fin (L + 1) → ℝ)
    (u : ℝ → ℝ) (w : ℝ) (d : Fin 2 → ℝ) (u_bar : ℝ) : Prop :=
  ∀ e : Fin 2,
    u_bar ≥ (∑ l : Fin (L + 1), π e l * u (w - (l.val : ℝ))) - d e