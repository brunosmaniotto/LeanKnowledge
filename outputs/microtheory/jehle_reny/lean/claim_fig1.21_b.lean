import Mathlib
open Topology

/-- Symmetry of the Slutsky substitution terms for Marshallian demands.
    From Slutsky matrix symmetry (Theorem 1.16): s_{ij} = s_{ji},
    where s_{ij} = ∂x_i/∂p_j + x_j(p,y)·∂x_i/∂y. -/
theorem Claim_Fig1_21_b
    (n : ℕ)
    (dxdp : Fin n → Fin n → ℝ)  -- ∂x_i(p,y)/∂p_j
    (dxdy : Fin n → ℝ)          -- ∂x_i(p,y)/∂y
    (xval : Fin n → ℝ)          -- x_i(p,y)
    -- Slutsky substitution term: s_{ij} = ∂x_i/∂p_j + x_j · ∂x_i/∂y
    (s : Fin n → Fin n → ℝ)
    (hs_def : ∀ i j, s i j = dxdp i j + xval j * dxdy i)
    -- Slutsky matrix is symmetric (Theorem 1.16)
    (hs_symm : ∀ i j, s i j = s j i) :
    ∀ i j : Fin n,
      dxdp i j + xval j * dxdy i = dxdp j i + xval i * dxdy j := by
  intro i j
  have h1 := hs_def i j
  have h2 := hs_def j i
  have h3 := hs_symm i j
  linarith