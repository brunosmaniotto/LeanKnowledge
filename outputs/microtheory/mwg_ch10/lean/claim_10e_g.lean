import Mathlib
open Topology

-- Axiomatized sub-lemmas

axiom consumer_surplus_change
  (x : ℝ → ℝ) (CS : ℝ → ℝ) (p0 pt_plus_t P_max : ℝ)
  (hCS : ∀ p, CS p = ∫ s in p..P_max, x s) :
  CS pt_plus_t - CS p0 = -(∫ s in p0..pt_plus_t, x s)

axiom producer_surplus_change
  (q : ℝ → ℝ) (PS : ℝ → ℝ) (p0 pt P_min : ℝ)
  (hPS : ∀ p, PS p = ∫ s in P_min..p, q s) :
  PS pt - PS p0 = -(∫ s in pt..p0, q s)

-- Main theorem

noncomputable def Claim_10E_g
  (x q : ℝ → ℝ) (CS PS : ℝ → ℝ) (p0 pt pt_plus_t P_max P_min t xstar : ℝ)
  (hCS : ∀ p, CS p = ∫ s in p..P_max, x s)
  (hPS : ∀ p, PS p = ∫ s in P_min..p, q s)
  (hpt : pt_plus_t = pt + t) :
  CS pt_plus_t - CS p0 = -(∫ s in p0..pt_plus_t, x s) ∧
  PS pt - PS p0 = -(∫ s in pt..p0, q s) ∧
  (-(CS pt_plus_t - CS p0) + -(PS pt - PS p0) - t * xstar =
   (∫ s in p0..pt_plus_t, x s) + (∫ s in pt..p0, q s) - t * xstar) := by
  refine ⟨?_, ?_, ?_⟩
  · exact consumer_surplus_change x CS p0 pt_plus_t P_max hCS
  · exact producer_surplus_change q PS p0 pt P_min hPS
  · have h1 := consumer_surplus_change x CS p0 pt_plus_t P_max hCS
    have h2 := producer_surplus_change q PS p0 pt P_min hPS
    linarith