# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

#######################################################
# Enhanced version of find mlir with corresponding llvm.
#
# Usage:
#   find_mlir(${USE_MLIR})
#
# - When both USE_MLIR=/path/to/MLIRConfig.cmake,
#   use mlir with corresponding llvm
#
# Provide variables:
# - LLVM_DIR
# - MLIR_DIR
# - MLIR_INCLUDE_DIRS
# - MLIR_LIBS
#
macro(find_mlir use_mlir)
  if(${use_mlir} MATCHES ${IS_FALSE_PATTERN})
    return()
  endif()

  find_package(MLIR REQUIRED CONFIG HINTS "${use_mlir}")

  message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")
  message(STATUS "Using MLIRConfig.cmake in: ${MLIR_DIR}")

  list(APPEND CMAKE_MODULE_PATH "${MLIR_DIR}")
  list(APPEND CMAKE_MODULE_PATH "${LLVM_DIR}")
  include(TableGen)
  include(AddLLVM)
  include(AddMLIR)
  include(HandleLLVMOptions)

  get_property(mlir_all_libnames GLOBAL PROPERTY MLIR_ALL_LIBS)

  set (MLIR_LIBS "")
  foreach(libname ${mlir_all_libnames})
    string(CONCAT lib "${LLVM_LIBRARY_DIR}/" "lib" "${libname}" ".a")
    if(EXISTS ${lib})
      list(APPEND MLIR_LIBS ${lib})
    endif()
  endforeach()

  message(STATUS "Found MLIR LIBS=" "${MLIR_LIBS}")
  message(STATUS "Found MLIR_INCLUDE_DIRS=" "${MLIR_INCLUDE_DIRS}")
endmacro(find_mlir)
