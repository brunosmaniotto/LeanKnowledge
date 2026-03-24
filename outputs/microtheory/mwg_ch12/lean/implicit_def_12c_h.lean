import Mathlib

open Set
open Topology

/--
The Representative Consumer Model (Spence, 1976; Dixit and Stiglitz, 1977).
A representative consumer has preferences over `J` products `(x₁,...,x_J)` and a numeraire good `m`.
The utility function is of the quasilinear form `G(Σ_{j=1}^J f(x_j)) + m`.
Both `G(·)` and `f(·)` are concave and differentiable.
The First-Order Conditions (FOCs) for the consumer's problem are
`G'(Σ f(x_j))f'(x_j) = p_j` for `j = 1,...,J`, which can be inverted to yield demand functions `x_j(p₁,...,p_J)`.

**Context**: An alternative to spatial formulations in which each product competes for sales with all other products.
-/
structure RepresentativeConsumerModel (J : ℕ) where
  /-- The outer function in the utility component for products. -/
  G : ℝ → ℝ
  /-- The inner function in the utility component for products. -/
  f : ℝ → ℝ
  /-- `G` is a concave function on its entire domain `ℝ`. -/
  G_concave : ConcaveOn ℝ univ G
  /-- `f` is a concave function on its entire domain `ℝ`. -/
  f_concave : ConcaveOn ℝ univ f
  /-- `G` is differentiable on its entire domain `ℝ`. This is required for the FOCs. -/
  G_differentiable : Differentiable ℝ G
  /-- `f` is differentiable on its entire domain `ℝ`. This is required for the FOCs. -/
  f_differentiable : Differentiable ℝ f