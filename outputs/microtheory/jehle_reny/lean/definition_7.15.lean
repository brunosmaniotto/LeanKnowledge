import Mathlib
open Topology

/-- A finite extensive-form game tree with perfect information for `n` players.
    - `leaf payoff`: a terminal node with payoff vector `payoff : Fin n → ℝ`.
    - `node mover k hk children`: a decision node where player `mover` chooses
      among `k > 0` actions (indexed by `Fin k`), each leading to subtree `children a`. -/
inductive GameTree (n : ℕ) where
  | leaf (payoff : Fin n → ℝ)
  | node (mover : Fin n) (k : ℕ) (hk : 0 < k) (children : Fin k → GameTree n)

namespace GameTree

/-- The backward induction payoff vector, computed recursively from the leaves.
    At a terminal node, returns the terminal payoff. At a decision node, the mover
    selects the action maximizing their payoff (ties broken by `Classical.choose`),
    and the subtree's backward induction payoff is returned.
    This implements the iterative procedure of Definition 7.15. -/
noncomputable def biPayoff : GameTree n → (Fin n → ℝ)
  | .leaf u => u
  | .node mover k hk children =>
    let f : Fin k → ℝ := fun a => (children a).biPayoff mover
    haveI : Nonempty (Fin k) := ⟨⟨0, hk⟩⟩
    let best : Fin k :=
      (Finset.exists_max_image Finset.univ f Finset.univ_nonempty).choose
    (children best).biPayoff

/-- The backward induction action at a decision node: the action index in `Fin k`
    that maximizes the mover's backward-induction payoff. The collection of these
    across all decision nodes forms the backward induction joint pure strategy. -/
noncomputable def biAction (mover : Fin n) (k : ℕ) (hk : 0 < k)
    (children : Fin k → GameTree n) : Fin k :=
  haveI : Nonempty (Fin k) := ⟨⟨0, hk⟩⟩
  let f : Fin k → ℝ := fun a => (children a).biPayoff mover
  (Finset.exists_max_image Finset.univ f Finset.univ_nonempty).choose

end GameTree