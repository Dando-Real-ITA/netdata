#!/bin/sh
#
# Invoked by the package builder images to actually build native packages.

PKG_TYPE="${1}"
BUILD_DIR="${2}"
SCRIPT_SOURCE="$(
    self=${0}
    while [ -L "${self}" ]
    do
        cd "${self%/*}" || exit 1
        self=$(readlink "${self}")
    done
    cd "${self%/*}" || exit 1
    echo "$(pwd -P)/${self##*/}"
)"
SOURCE_DIR="$(dirname "${SCRIPT_SOURCE}")"

CMAKE_ARGS="-S ${SOURCE_DIR} -B ${BUILD_DIR} -G Ninja"

add_cmake_option() {
    CMAKE_ARGS="${CMAKE_ARGS} -D${1}=${2}"
}

add_cmake_option CMAKE_BUILD_TYPE RelWithDebInfo
add_cmake_option CMAKE_INSTALL_PREFIX /
add_cmake_option ENABLE_ACLK On
add_cmake_option ENABLE_CLOUD On
add_cmake_option ENABLE_DBENGINE On
add_cmake_option ENABLE_H2O On
add_cmake_option ENABLE_ML On

add_cmake_option ENABLE_PLUGIN_APPS On
add_cmake_option ENABLE_PLUGIN_CGROUP_NETWORK On
add_cmake_option ENABLE_PLUGIN_DEBUGFS On
add_cmake_option ENABLE_PLUGIN_FREEIPMI On
add_cmake_option ENABLE_PLUGIN_GO On
add_cmake_option ENABLE_PLUGIN_LOCAL_LISTENERS On
add_cmake_option ENABLE_PLUGIN_LOGS_MANAGEMENT On
add_cmake_option ENABLE_PLUGIN_NFACCT On
add_cmake_option ENABLE_PLUGIN_PERF On
add_cmake_option ENABLE_PLUGIN_SLABINFO On
add_cmake_option ENABLE_PLUGIN_SYSTEMD_JOURNAL On

add_cmake_option ENABLE_EXPORTER_PROMETHEUS_REMOTE_WRITE On
add_cmake_option ENABLE_EXPORTER_MONGODB On

add_cmake_option ENABLE_BUNDLED_PROTOBUF Off
add_cmake_option ENABLE_BUNDLED_JSONC Off
add_cmake_option ENABLE_BUNDLED_YAML Off

case "${PKG_TYPE}" in
    DEB)
        if [ "$(uname -m)" = "x86_64" ]; then
            "${SOURCE_DIR}/packaging/bundle_libbpf.sh" "${BUILD_DIR}" ''
            add_cmake_option ENABLE_EBPF On
        else
            add_cmake_option ENABLE_EBPF Off
        fi
        case "$(uname -m)" in
            x86_64|arm64) add_cmake_option ENABLE_XENSTAT On ;;
            *) add_cmake_option ENABLE_XENSTAT Off
        esac
        ;;
    RPM) ;;
    *) echo "Unrecognized package type ${PKG_TYPE}." ; exit 1 ;;
esac

# shellcheck disable=SC2086
cmake ${CMAKE_ARGS}
cmake --build "${BUILD_DIR}" --parallel "$(nproc)"
cpack -B "${BUILD_DIR}" -G "${PACKAGE_TYPE}"