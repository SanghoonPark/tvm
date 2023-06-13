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

if(NOT ${USE_MLIR} MATCHES ${IS_FALSE_PATTERN})
  find_mlir(${USE_MLIR})

  # Enable build with LLVM support if it is disabled.
  if(${USE_LLVM} MATCHES ${IS_FALSE_PATTERN})
    set(USE_LLVM "${LLVM_BUILD_BINARY_DIR}/bin/llvm-config")
    include(cmake/modules/LLVM.cmake)
  endif()

  include_directories(SYSTEM ${MLIR_INCLUDE_DIRS})
  tvm_file_glob(GLOB COMPILER_MLIR_SRCS src/target/mlir/*.cc)
  list(APPEND TVM_LINKER_LIBS ${MLIR_LIBS})
  list(APPEND COMPILER_SRCS ${COMPILER_MLIR_SRCS})
endif()
