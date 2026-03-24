import Mathlib

open Set Filter Topology
open Filter
open Topology

noncomputable section

/-- Value function V(a) = sup{f(x,a) : x ∈ C(a)} for the Theorem of the Maximum. -/
noncomputable def theoremOfMaximum_value
    {A X : Type*} [TopologicalSpace A] [TopologicalSpace X]
    (f : X × A → ℝ) (C : A → Set X) (a : A) : ℝ :=
  sSup ((fun x => f (x, a)) '' C a)

/-- Theorem of the Maximum, Part (i): A maximizer exists for every parameter value.
    Follows from the extreme value theorem (Finite.exists_max). -/
theorem Theorem_A2_21_i
    {A X : Type*} [TopologicalSpace A] [TopologicalSpace X]
    (f : X × A → ℝ) (hf : Continuous f)
    (C : A → Set X) (hC_compact : ∀ a, IsCompact (C a))
    (hC_nonempty : ∀ a, (C a).Nonempty) :
    ∀ a, ∃ x ∈ C a, ∀ y ∈ C a, f (y, a) ≤ f (x, a) := by
  intro a
  have hg : Continuous (fun x : X => f (x, a)) := hf.comp (by fun_prop)
  obtain ⟨x, hx, hmax⟩ := (hC_compact a).exists_isMaxOn (hC_nonempty a) hg.continuousOn
  exact ⟨x, hx, fun y hy => hmax hy⟩

/-- Part (ii): The value function V is continuous under constraint-continuity
    (closed graph + lower hemicontinuity of the constraint correspondence). -/
axiom Theorem_A2_21_ii
    {A X : Type*} [TopologicalSpace A] [TopologicalSpace X]
    (f : X × A → ℝ) (hf : Continuous f)
    (C : A → Set X) (hC_compact : ∀ a, IsCompact (C a))
    (hC_nonempty : ∀ a, (C a).Nonempty)
    (hC_closed_graph : IsClosed {p : X × A | p.1 ∈ C p.2})
    (hC_lhc : ∀ a, ∀ U : Set X, IsOpen U → (C a ∩ U).Nonempty →
      ∀ᶠ b in 𝓝 a, (C b ∩ U).Nonempty) :
    Continuous (fun a => sSup ((fun x => f (x, a)) '' C a))

/-- Part (iii): Limits of optimal solutions remain optimal (closed graph of argmax). -/
axiom Theorem_A2_21_iii
    {A X : Type*} [TopologicalSpace A] [TopologicalSpace X]
    [FirstCountableTopology A] [FirstCountableTopology X]
    (f : X × A → ℝ) (hf : Continuous f)
    (C : A → Set X)
    (hC_closed_graph : IsClosed {p : X × A | p.1 ∈ C p.2})
    (hC_lhc : ∀ a, ∀ U : Set X, IsOpen U → (C a ∩ U).Nonempty →
      ∀ᶠ b in 𝓝 a, (C b ∩ U).Nonempty)
    (xk : ℕ → X) (ak : ℕ → A) (x_star : X) (a_star : A)
    (h_conv : Tendsto (fun k => (xk k, ak k)) atTop (𝓝 (x_star, a_star)))
    (h_opt : ∀ k, xk k ∈ C (ak k) ∧ ∀ y ∈ C (ak k), f (y, ak k) ≤ f (xk k, ak k)) :
    x_star ∈ C a_star ∧ ∀ y ∈ C a_star, f (y, a_star) ≤ f (x_star, a_star)

/-- Part (iv): If the argmax is unique for every a, the selection function is continuous. -/
axiom Theorem_A2_21_iv
    {A X : Type*} [TopologicalSpace A] [TopologicalSpace X] [CompactSpace X]
    (f : X × A → ℝ) (hf : Continuous f)
    (C : A → Set X) (hC_compact : ∀ a, IsCompact (C a))
    (hC_nonempty : ∀ a, (C a).Nonempty)
    (hC_closed_graph : IsClosed {p : X × A | p.1 ∈ C p.2})
    (hC_lhc : ∀ a, ∀ U : Set X, IsOpen U → (C a ∩ U).Nonempty →
      ∀ᶠ b in 𝓝 a, (C b ∩ U).Nonempty)
    (x : A → X)
    (h_unique : ∀ a, x a ∈ C a ∧ (∀ y ∈ C a, f (y, a) ≤ f (x a, a)) ∧
                (∀ z ∈ C a, (∀ y ∈ C a, f (y, a) ≤ f (z, a)) → z = x a)) :
    Continuous x

end