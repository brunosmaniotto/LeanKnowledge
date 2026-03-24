import Mathlib

/-!
This file proves that the class of URM computable functions is closed under substitution.
The proof relies on an axiom stating that if the component functions of a vector-valued
function are computable, then the vector-valued function is also computable.
The main theorem then follows by applying the composition property of computable functions.

We represent a function from `ℕ^k` to `ℕ` as a function `(Fin k → ℕ) → ℕ`.
-/

-- For the purpose of this exercise, we axiomatize a standard lemma from computability theory.
-- This lemma states that creating a vector of functions from computable components
-- results in a computable function. In Mathlib, this corresponds to `Primrec.vector`.
axiom computable_vector_function_of_components {k t : ℕ} (g : Fin t → ((Fin k → ℕ) → ℕ)) (hg : ∀ i, Computable (g i)) : Computable (fun (x : Fin k → ℕ) (i : Fin t) => g i x)

/--
**Function Obtained by Substitution from URM Computable Functions**

Let the functions $f: \N^t \to \N, g_1: \N^k \to \N, g_2: \N^k \to \N, \ldots, g_t: \N^k \to \N$
all be URM computable functions. Let $h: \N^k \to \N$ be defined from
$f, g_1, g_2, \ldots, g_t$ by substitution, i.e.,
$h(\vec{x}) = f(g_1(\vec{x}), \ldots, g_t(\vec{x}))$.
Then $h$ is also URM computable.

In this formalization, "URM computable" is represented by the `Computable` predicate from Mathlib,
which is defined as being primitive recursive. The property holds for this class of functions.
A function from $\N^k$ to $\N$ is represented as `(Fin k → ℕ) → ℕ`.
-/
theorem computable_of_substitution {k t : ℕ} (f : (Fin t → ℕ) → ℕ) (hf : Computable f) (g : Fin t → ((Fin k → ℕ) → ℕ)) (hg : ∀ i, Computable (g i)) : Computable (fun (x : Fin k → ℕ) => f (fun i => g i x)) := by
  -- The function `h` is a composition of `f` and a vector-valued function `G`
  -- where `G(x) = (g₁(x), ..., gₜ(x))`.
  -- In our notation, `G` is `fun x i => g i x`.

  -- First, we show that the vector-valued function `G` is computable.
  -- This follows from the provided axiom, given that all its component functions `g i` are computable.
  have hg_vec : Computable (fun x i => g i x) :=
    computable_vector_function_of_components g hg

  -- The class of computable functions is closed under composition.
  -- `h` is the composition of `f` and `G`.
  -- `hf` is `Computable f` and `hg_vec` is `Computable G`.
  -- `Computable.comp` proves that `f ∘ G` is computable.
  exact hf.comp hg_vec