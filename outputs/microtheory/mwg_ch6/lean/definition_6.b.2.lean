import Mathlib
open Topology
open BigOperators

/-- A simple lottery over `N` outcomes: a probability mass function on `Fin N`.
    Encodes probabilities p_n ≥ 0 with ∑ p_n = 1. -/
abbrev SimpleLottery (N : ℕ) := PMF (Fin N)

/-- Definition 6.B.2: A compound lottery (L₁, …, L_K; α₁, …, α_K) consists of
    K simple lotteries and a probability distribution over them (the mixing weights). -/
structure CompoundLottery (N K : ℕ) where
  lotteries : Fin K → SimpleLottery N
  weights : PMF (Fin K)

/-- The compound lottery reduces to a simple lottery: outcome n gets probability
    ∑_k α_k · p^k_n. This is exactly PMF.bind (the monadic bind for probability). -/
noncomputable def CompoundLottery.reduce {N K : ℕ}
    (c : CompoundLottery N K) : SimpleLottery N :=
  c.weights.bind c.lotteries