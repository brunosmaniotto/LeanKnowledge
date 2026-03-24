import Mathlib

structure BayesianGame where
  Player : Type*
  TypeSpace : Player → Type*
  ActionSpace : Player → Type*

def BayesStrategy (G : BayesianGame) := (i : G.Player) → G.TypeSpace i → G.ActionSpace i

axiom IsBNE (G : BayesianGame) (σ : BayesStrategy G) : Prop
axiom IsSeqEq (G : BayesianGame) (σ : BayesStrategy G) : Prop

axiom bne_imp_seq (G : BayesianGame) (σ : BayesStrategy G) :
  IsBNE G σ → IsSeqEq G σ

axiom seq_imp_bne (G : BayesianGame) (σ : BayesStrategy G) :
  IsSeqEq G σ → IsBNE G σ