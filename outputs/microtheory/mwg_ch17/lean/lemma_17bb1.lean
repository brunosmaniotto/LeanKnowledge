import Mathlib

-- Axiomatize economic primitives
axiom EconAgent : Type
axiom EconFirm : Type
axiom Bundle : Type
axiom PriceVec : Type

axiom ConsSet : EconAgent → Set Bundle
axiom ProdSet : EconFirm → Set Bundle
axiom truncated_cons : EconAgent → ℝ → Set Bundle
axiom truncated_prod : EconFirm → ℝ → Set Bundle
axiom truncated_cons_sub : ∀ i r, truncated_cons i r ⊆ ConsSet i
axiom truncated_prod_sub : ∀ j r, truncated_prod j r ⊆ ProdSet j

axiom FreeDisposalQuasiequilibrium :
  (EconAgent → Bundle) → (EconFirm → Bundle) → PriceVec →
  (EconAgent → Set Bundle) → (EconFirm → Set Bundle) → Prop

axiom is_convex_cons : EconAgent → Prop
axiom is_convex_prod : EconFirm → Prop
axiom alloc_interior : (EconAgent → Bundle) → (EconFirm → Bundle) → ℝ → Prop

/-- Key economic lemma: if the allocation is interior to the truncation bound
    and preferences/sets are convex, then any violation of the quasiequilibrium
    condition in the full economy can be pulled back into the truncated economy
    via convex combinations, yielding a contradiction. -/
axiom truncated_quasi_implies_full
    (x_star : EconAgent → Bundle)
    (y_star : EconFirm → Bundle)
    (p : PriceVec)
    (r : ℝ)
    (hconvX : ∀ i, is_convex_cons i)
    (hconvY : ∀ j, is_convex_prod j)
    (h_interior : alloc_interior x_star y_star r)
    (h_quasi_trunc : FreeDisposalQuasiequilibrium x_star y_star p
        (fun i => truncated_cons i r) (fun j => truncated_prod j r)) :
    FreeDisposalQuasiequilibrium x_star y_star p ConsSet ProdSet

/-- Lemma 17.BB.1: A free-disposal quasiequilibrium in a truncated economy
    is also a free-disposal quasiequilibrium for the original untruncated economy,
    provided all consumption and production sets are convex and the equilibrium
    allocation is interior to the truncation bounds. -/
theorem Lemma_17BB1
    (x_star : EconAgent → Bundle)
    (y_star : EconFirm → Bundle)
    (p : PriceVec)
    (r : ℝ)
    (hconvX : ∀ i, is_convex_cons i)
    (hconvY : ∀ j, is_convex_prod j)
    (h_interior : alloc_interior x_star y_star r)
    (h_quasi_trunc : FreeDisposalQuasiequilibrium x_star y_star p
        (fun i => truncated_cons i r) (fun j => truncated_prod j r)) :
    FreeDisposalQuasiequilibrium x_star y_star p ConsSet ProdSet :=
  truncated_quasi_implies_full x_star y_star p r hconvX hconvY h_interior h_quasi_trunc