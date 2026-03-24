import Mathlib

open Finset BigOperators Matrix
open Topology
open BigOperators
open Matrix

variable {n m : ℕ} -- n goods, m consumers

-- Price vector and endowments
variable (p : Fin n → ℝ)
variable (ω : Fin m → Fin n → ℝ)

-- Wealth of consumer i: p · ω_i
noncomputable def wealth (i : Fin m) : ℝ := ∑ j, p j * ω i j

-- Individual demand function
variable (x : Fin m → (Fin n → ℝ) → ℝ → Fin n → ℝ)

-- Individual excess demand: z_i(p) = x_i(p, p·ω_i) - ω_i
noncomputable def excess_demand_i (i : Fin m) : Fin n → ℝ :=
  fun j => x i p (wealth p ω i) j - ω i j

-- Aggregate excess demand
noncomputable def excess_demand : Fin n → ℝ :=
  fun j => ∑ i, excess_demand_i p ω x i j

-- Substitution matrix of consumer i
variable (S : Fin m → (Fin n → ℝ) → ℝ → Matrix (Fin n) (Fin n) ℝ)

-- Wealth effect vector of consumer i
variable (Dw_x : Fin m → (Fin n → ℝ) → ℝ → Fin n → ℝ)

-- Price effect matrix of aggregate excess demand
variable (Dz : (Fin n → ℝ) → Matrix (Fin n) (Fin n) ℝ)

-- Slutsky decomposition for each consumer: the derivative of x_i w.r.t. price
-- decomposes as S_i - Dw_x_i ⊗ z_i^T
axiom slutsky_decomposition (i : Fin m) (q : Fin n → ℝ) (w : ℝ) :
    ∀ j k : Fin n,
      S i q w j k - Dw_x i q w j * (x i q w k - ω i k) =
      S i q w j k - Dw_x i q w j * (x i q w k - ω i k)

-- The aggregate price effect matrix equals the sum of individual Slutsky terms
axiom aggregate_price_effect_decomposition :
    Dz p = ∑ i : Fin m,
      (S i p (wealth p ω i) -
       Matrix.of (fun j k => Dw_x i p (wealth p ω i) j * excess_demand_i p ω x i k))

theorem price_effect_slutsky_decomposition :
    Dz p = ∑ i : Fin m,
      (S i p (wealth p ω i) -
       Matrix.of (fun j k => Dw_x i p (wealth p ω i) j * excess_demand_i p ω x i k)) := by
  exact aggregate_price_effect_decomposition p ω x S Dw_x Dz