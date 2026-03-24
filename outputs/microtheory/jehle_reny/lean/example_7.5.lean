import Mathlib
open Topology
open Set -- For Set Node

-- Define the structure of an ExtensiveFormGame based on the problem description.
-- This structure is defined here to ensure it's a known identifier.
structure ExtensiveFormGame (Node : Type*) (Player : Type*) where
  players : Type*
  actions : Node → Type*
  next_node : Node → (∀ (n : Node), actions n) → Node
  player : Node → Player
  info_set : Node → Set Node
  is_decision : Node → Prop
  is_terminal : Node → Prop

-- Define Players in the game
inductive Player : Type where
  | Seller : Player
  | Buyer : Player
  deriving DecidableEq, Fintype

-- Define all possible Actions in the game
inductive UsedCarAction : Type where
  | Repair : UsedCarAction
  | DontRepair : UsedCarAction
  | PriceHigh : UsedCarAction
  | PriceLow : UsedCarAction
  | Accept : UsedCarAction
  | Reject : UsedCarAction
  deriving DecidableEq, Fintype

open Player UsedCarAction

-- Define the nodes of the game tree using an inductive type
inductive UsedCarGameNode : Type where
  | Initial : UsedCarGameNode
  | SellerRepairDecision (repair_act : UsedCarAction) : UsedCarGameNode
  | SellerPriceDecision (repair_act : UsedCarAction) (price_act : UsedCarAction) : UsedCarGameNode
  | BuyerDecision (repair_act : UsedCarAction) (price_act : UsedCarAction) (buyer_act : UsedCarAction) : UsedCarGameNode
  deriving DecidableEq

open UsedCarGameNode

-- Instantiate the ExtensiveFormGame for the buyer-seller used car game
noncomputable def usedCarGame : ExtensiveFormGame UsedCarGameNode Player where
  players := Player -- Assign the Player type itself
  
  -- The type of actions available at any node is `UsedCarAction`
  actions := fun _ => UsedCarAction

  -- The `next_node` function determines the next node based on the current node
  -- and the action chosen for that node from the action profile.
  next_node := fun node (action_profile : UsedCarGameNode → UsedCarAction) =>
    let current_action := action_profile node
    match node, current_action with
    | Initial, .Repair => SellerRepairDecision Repair
    | Initial, .DontRepair => SellerRepairDecision DontRepair
    | Initial, _ => Initial -- If invalid action for Initial, remain at Initial node

    | SellerRepairDecision repair_act_val, .PriceHigh => SellerPriceDecision repair_act_val PriceHigh
    | SellerRepairDecision repair_act_val, .PriceLow => SellerPriceDecision repair_act_val PriceLow
    | SellerRepairDecision repair_act_val, _ => SellerRepairDecision repair_act_val -- Invalid action, remain

    | SellerPriceDecision repair_act_val price_act_val, .Accept => BuyerDecision repair_act_val price_act_val Accept
    | SellerPriceDecision repair_act_val price_act_val, .Reject => BuyerDecision repair_act_val price_act_val Reject
    | SellerPriceDecision repair_act_val price_act_val, _ => SellerPriceDecision repair_act_val price_act_val -- Invalid action, remain

    | BuyerDecision _ _ _, _ => node -- Terminal node, no further moves possible

  -- Defines which player moves at each node
  player := fun node =>
    match node with
    | Initial => Seller
    | SellerRepairDecision _ => Seller
    | SellerPriceDecision _ _ => Buyer
    | BuyerDecision _ _ _ => Buyer -- Terminal node, but assigned for completeness

  -- Defines the information set for each node.
  -- At node `(repair, price high)`, the buyer observes `PriceHigh` but not `Repair` vs `DontRepair`.
  info_set := fun node =>
    match node with
    | SellerPriceDecision _ .PriceHigh =>
      {SellerPriceDecision Repair PriceHigh, SellerPriceDecision DontRepair PriceHigh}
    | _ => {node} -- For all other nodes, the information set is a singleton (perfect information).

  -- Indicates whether a node is a decision node
  is_decision := fun node =>
    match node with
    | Initial => true
    | SellerRepairDecision _ => true
    | SellerPriceDecision _ _ => true
    | BuyerDecision _ _ _ => false -- Terminal node, not a decision node

  -- Indicates whether a node is a terminal node
  is_terminal := fun node =>
    match node with
    | BuyerDecision _ _ _ => true
    | _ => false

-- Theorem: States the specific information set property at node `(repair, price high)`.
theorem Example_7_5 :
  (usedCarGame.info_set (SellerPriceDecision Repair PriceHigh)) =
  {SellerPriceDecision Repair PriceHigh, SellerPriceDecision DontRepair PriceHigh} :=
by
  -- The equality holds by definition, so `rfl` (reflexivity) completes the proof.
  rfl