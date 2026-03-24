import Mathlib

open Set
open Topology

/--
When fixed costs are sunk, the firm's supply decision depends only on variable costs.
Key result: if Cv is convex with Cv(0) = 0, then p = Cv'(q) implies p * q ≥ Cv(q),
i.e., the firm covers its variable costs at the optimum.
-/
theorem Claim_5D_d
    (Cv : ℝ → ℝ)
    (K : ℝ)
    (hconv : ConvexOn ℝ (Set.Ici 0) Cv)
    (hCv0 : Cv 0 = 0)
    (q : ℝ)
    (hq : 0 ≤ q)
    (p : ℝ)
    -- p is a subgradient of Cv at q: for all x ≥ 0, Cv(x) ≥ Cv(q) + p * (x - q)
    (hsubgrad : ∀ x : ℝ, 0 ≤ x → Cv x ≥ Cv q + p * (x - q))
    -- The total cost is variable + sunk fixed cost
    (C : ℝ → ℝ)
    (hC : ∀ x : ℝ, 0 ≤ x → C x = Cv x + K) :
    -- The firm covers variable costs: p * q ≥ Cv(q)
    p * q ≥ Cv q := by
  have h0 := hsubgrad 0 (le_refl 0)
  rw [hCv0] at h0
  -- h0 : 0 ≥ Cv q + p * (0 - q), i.e., p * q ≥ Cv q
  linarith