import Mathlib

-- Borda count violates Independence of Irrelevant Alternatives (IIA)
-- We demonstrate with 2 voters, 3 alternatives {x, y, z}

inductive Alt3 : Type where
  | x | y | z
  deriving DecidableEq, Fintype, Repr

open Alt3
open Topology

-- A preference is a ranking: Alt3 → Fin 3 (0 = best, 2 = worst)
-- Borda score = sum over voters of (n-1 - rank), with n=3 alternatives
-- So score = sum of (2 - rank_i(a))

-- Profile 1: voter1: x>y>z, voter2: y>z>x
-- ranks: v1(x)=0, v1(y)=1, v1(z)=2; v2(y)=0, v2(z)=1, v2(x)=2
-- Borda(x) = (2-0)+(2-2) = 2, Borda(y) = (2-1)+(2-0) = 3
-- So y beats x in profile 1

-- Profile 2: voter1: x>z>y, voter2: y>x>z
-- ranks: v1(x)=0, v1(z)=1, v1(y)=2; v2(y)=0, v2(x)=1, v2(z)=2
-- Borda(x) = (2-0)+(2-1) = 3, Borda(y) = (2-2)+(2-0) = 2
-- So x beats y in profile 2

-- In both profiles, voter 1 prefers x to y, voter 2 prefers y to x.
-- Yet the social ranking of x vs y flips. This violates IIA.

theorem borda_violates_iia :
    -- There exist two preference profiles (as ranking functions)
    -- such that both voters rank x vs y the same way in both profiles,
    -- but the Borda winner between x and y changes.
    ∃ (rank1 rank2 : Fin 2 → Alt3 → Fin 3),
      -- Voter 0 ranks x above y in both profiles
      (rank1 0 Alt3.x < rank1 0 Alt3.y) ∧
      (rank2 0 Alt3.x < rank2 0 Alt3.y) ∧
      -- Voter 1 ranks y above x in both profiles
      (rank1 1 Alt3.y < rank1 1 Alt3.x) ∧
      (rank2 1 Alt3.y < rank2 1 Alt3.x) ∧
      -- Borda score of x < Borda score of y in profile 1 (y wins)
      (Finset.univ.sum (fun i => (2 : ℤ) - ↑(rank1 i Alt3.x)) <
       Finset.univ.sum (fun i => (2 : ℤ) - ↑(rank1 i Alt3.y))) ∧
      -- Borda score of x > Borda score of y in profile 2 (x wins)
      (Finset.univ.sum (fun i => (2 : ℤ) - ↑(rank2 i Alt3.x)) >
       Finset.univ.sum (fun i => (2 : ℤ) - ↑(rank2 i Alt3.y))) := by
  -- Profile 1: v0: x=0,y=1,z=2; v1: y=0,z=1,x=2
  -- Profile 2: v0: x=0,z=1,y=2; v1: y=0,x=1,z=2
  refine ⟨
    ![fun a => match a with | .x => 0 | .y => 1 | .z => 2,
      fun a => match a with | .x => 2 | .y => 0 | .z => 1],
    ![fun a => match a with | .x => 0 | .y => 2 | .z => 1,
      fun a => match a with | .x => 1 | .y => 0 | .z => 2],
    ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> native_decide