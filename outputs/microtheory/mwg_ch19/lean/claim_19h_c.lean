import Mathlib

structure REModel where
  S : Type*
  I : Type*
  Price : Type*
  Demand : Type*
  [sFintype : Fintype S]
  [iFintype : Fintype I]
  pHat : S → Price
  privateSignal : I → S → S
  demandPooled : I → S → Price → Demand
  demandPrivate : I → S → Price → Demand

def REModel.fullyRevealing (M : REModel) : Prop :=
  Function.Injective M.pHat