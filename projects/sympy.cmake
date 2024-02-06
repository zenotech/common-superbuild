superbuild_python_version_check(sympy
  "3.5" "0" # Unsupported
  "3.6" "1.9"
  "3.7" "1.10.1")

set(sympy_test_modules)
if (sympy_SOURCE_SELECTION VERSION_GREATER_EQUAL "1.10.1")
  list(APPEND sympy_test_modules
    sympy.polys.numberfields.tests
    )
endif ()

superbuild_add_project_python(sympy
  PACKAGE
    sympy
  DEPENDS
    pythonsetuptools
    pythonmpmath
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2006-2023 SymPy Development Team"
    "Copyright (c) 2006-2018 SymPy Development Team, 2013-2023 Sergey B Kirpichev"
    "Copyright (c) 2014 Matthew Rocklin"
    "Copyright (c) 2009-2023, PyDy Authors"
    "Copyright 2016, latex2sympy"
  REMOVE_MODULES
    sympy.algebras.tests
    sympy.assumptions.tests
    sympy.calculus.tests
    sympy.categories.tests
    sympy.codegen.tests
    sympy.combinatorics.tests
    sympy.concrete.tests
    sympy.core.tests
    sympy.crypto.tests
    sympy.diffgeom.tests
    sympy.discrete.tests
    sympy.external.tests
    sympy.functions.combinatorial.tests
    sympy.functions.elementary.tests
    sympy.functions.special.tests
    sympy.geometry.tests
    sympy.holonomic.tests
    sympy.integrals.tests
    sympy.interactive.tests
    sympy.liealgebras.tests
    sympy.logic.tests
    sympy.matrices.expressions.tests
    sympy.matrices.tests
    sympy.multipledispatch.tests
    sympy.ntheory.tests
    sympy.parsing.autolev.test-examples
    sympy.parsing.tests
    sympy.physics.continuum_mechanics.tests
    sympy.physics.control.tests
    sympy.physics.hep.tests
    sympy.physics.mechanics.tests
    sympy.physics.optics.tests
    sympy.physics.quantum.tests
    sympy.physics.tests
    sympy.physics.units.tests
    sympy.physics.vector.tests
    sympy.plotting.intervalmath.tests
    sympy.plotting.pygletplot.tests
    sympy.plotting.tests
    sympy.polys.agca.tests
    sympy.polys.domains.tests
    sympy.polys.matrices.tests
    sympy.polys.tests
    sympy.printing.pretty.tests
    sympy.printing.tests
    sympy.sandbox.tests
    sympy.series.tests
    sympy.sets.tests
    sympy.simplify.tests
    sympy.solvers.diophantine.tests
    sympy.solvers.ode.tests
    sympy.solvers.tests
    sympy.stats.sampling.tests
    sympy.stats.tests
    sympy.strategies.branch.tests
    sympy.strategies.tests
    sympy.tensor.array.expressions.tests
    sympy.tensor.array.tests
    sympy.tensor.tests
    sympy.testing.tests
    sympy.unify.tests
    sympy.utilities._compilation.tests
    sympy.utilities.tests
    sympy.vector.tests
  )
