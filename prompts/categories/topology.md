# Category Supplement: Topology

## Key imports
```lean
import Mathlib
open TopologicalSpace Set Filter Topology
```

## Core types
```
TopologicalSpace α     — a type with a topology
IsOpen s               — s is an open set
IsClosed s             — s is a closed set
IsCompact s            — s is compact
IsConnected s          — s is connected
Dense s                — s is dense
Continuous f           — f is continuous
IsHomeomorph f         — f is a homeomorphism
```

## Key lemmas
```
-- Open / closed sets
isOpen_univ             : IsOpen (Set.univ : Set α)
isOpen_empty            : IsOpen (∅ : Set α)
IsOpen.union            : IsOpen s → IsOpen t → IsOpen (s ∪ t)
IsOpen.inter            : IsOpen s → IsOpen t → IsOpen (s ∩ t)
isClosed_compl_iff      : IsClosed sᶜ ↔ IsOpen s

-- Continuity (equivalent characterizations)
continuous_def          : Continuous f ↔ ∀ s, IsOpen s → IsOpen (f ⁻¹' s)
Continuous.comp         : Continuous g → Continuous f → Continuous (g ∘ f)
continuous_id           : Continuous (id : α → α)
continuous_const        : Continuous (fun _ => c)

-- Compactness
IsCompact.isClosed      : IsCompact s → IsClosed s (in Hausdorff spaces)
isCompact_univ_iff      : IsCompact (univ : Set α) ↔ CompactSpace α
IsCompact.finite         : IsCompact s → Set.Finite s (for discrete spaces)

-- Connectedness
isConnected_univ_iff    : IsConnected (univ : Set α) ↔ ConnectedSpace α
IsPreconnected.union    : union of connected sets sharing a point

-- Hausdorff
T2Space                 — typeclass for Hausdorff spaces
t2_separation           : x ≠ y → ∃ u v, IsOpen u ∧ IsOpen v ∧ x ∈ u ∧ y ∈ v ∧ Disjoint u v
```

## Common patterns
```lean
-- Prove continuity by composing continuous functions
exact Continuous.add (continuous_fst) (continuous_snd)

-- Prove a set is open/closed
exact isOpen_lt continuous_id continuous_const

-- Use topological space typeclasses
variable [TopologicalSpace α] [T2Space α] [CompactSpace α]
```

## Common pitfalls
1. **Typeclass inference**: Most topology works through typeclasses. Make sure `[TopologicalSpace α]` is in scope.
2. **`Set.preimage` for continuity**: `f ⁻¹' s` is `Set.preimage f s`. The continuous preimage characterization uses this.
3. **Hausdorff hypothesis**: Many theorems (e.g., compact → closed) need `[T2Space α]`.
4. **Filter-based limits**: Topology in Mathlib uses filters extensively. Convergence is `Filter.Tendsto`.
5. **`IsOpen` vs `Opens`**: `IsOpen s` is a Prop about a set. `Opens α` is the type of open sets (a bundled type).

## Worked example: Composition of continuous functions
```lean
import Mathlib

theorem comp_continuous {α β γ : Type*} [TopologicalSpace α]
    [TopologicalSpace β] [TopologicalSpace γ]
    {f : α → β} {g : β → γ} (hf : Continuous f) (hg : Continuous g) :
    Continuous (g ∘ f) :=
  hg.comp hf
```
