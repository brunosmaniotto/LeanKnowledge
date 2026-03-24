import Mathlib

open MeasureTheory
open MeasureTheory.Measure
open Topology

/-
Definition: The aggregate consumer surplus when consumers face effective price p is CS(p).

This definition uses one of the equivalent forms provided: CS(p) = ∫_0^{x(p)} [P(s) − p]ds.
This form expresses consumer surplus as the area under the inverse demand curve P(s) and above the price p, up to the quantity demanded x(p).

Where:
- `P : ℝ → ℝ` is the inverse demand function (price as a function of quantity).
- `x : ℝ → ℝ` is the aggregate demand function (quantity as a function of price).
- `p : ℝ` is the effective market price.

This definition implicitly assumes that the integrand `(fun s => P s - p)` is integrable
on the interval `[min 0 (x p), max 0 (x p)]`. This condition is typically met if `P` is a continuous function.
-/
noncomputable def consumer_surplus (P : ℝ → ℝ) (x : ℝ → ℝ) (p : ℝ) : ℝ :=
  ∫ s in 0..(x p), (P s - p) ∂volume