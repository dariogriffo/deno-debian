DENO_VERSION=$1
BUILD_VERSION=$2
ARCH=${3:-amd64}

if [ -z "$DENO_VERSION" ] || [ -z "$BUILD_VERSION" ]; then
    echo "Usage: $0 <deno_version> <build_version> [architecture]"
    echo "Example: $0 2.7.2 1 arm64"
    echo "Example: $0 2.7.2 1 all    # Build for all architectures"
    echo "Supported architectures: amd64, arm64, all"
    exit 1
fi

# Map Ubuntu architecture to deno release name
get_deno_release() {
    local arch=$1
    case "$arch" in
        "amd64")
            echo "x86_64-unknown-linux-gnu"
            ;;
        "arm64")
            echo "aarch64-unknown-linux-gnu"
            ;;
        *)
            echo ""
            ;;
    esac
}

build_architecture() {
    local build_arch=$1
    local release_arch

    release_arch=$(get_deno_release "$build_arch")
    if [ -z "$release_arch" ]; then
        echo "❌ Unsupported architecture: $build_arch"
        echo "Supported architectures: amd64, arm64"
        return 1
    fi

    echo "Building for architecture: $build_arch using $release_arch"

    declare -a arr=("jammy" "noble" "questing")

    for dist in "${arr[@]}"; do
        FULL_VERSION="$DENO_VERSION-${BUILD_VERSION}+${dist}_${build_arch}_ubu"
        echo "  Building deno $FULL_VERSION"

        rm -f deno "deno-${release_arch}.zip"
        if ! wget "https://github.com/denoland/deno/releases/download/v${DENO_VERSION}/deno-${release_arch}.zip"; then
            echo "❌ Failed to download deno binary for $build_arch"
            return 1
        fi
        unzip -o "deno-${release_arch}.zip"
        rm -f "deno-${release_arch}.zip"

        if ! docker build . -f deno_Dockerfile.ubu -t "deno-ubuntu-$dist-$build_arch" \
            --build-arg DENO_VERSION="$DENO_VERSION" \
            --build-arg UBUNTU_DIST="$dist" \
            --build-arg BUILD_VERSION="$BUILD_VERSION" \
            --build-arg FULL_VERSION="$FULL_VERSION" \
            --build-arg ARCH="$build_arch"; then
            echo "❌ Failed to build Docker image for deno $dist on $build_arch"
            rm -f deno
            return 1
        fi

        id="$(docker create "deno-ubuntu-$dist-$build_arch")"
        docker cp "$id:/deno_$FULL_VERSION.deb" - > "./deno_$FULL_VERSION.deb"
        tar -xf "./deno_$FULL_VERSION.deb"
        rm -f deno

        echo "  Building denort $FULL_VERSION"

        rm -f denort "denort-${release_arch}.zip"
        if ! wget "https://github.com/denoland/deno/releases/download/v${DENO_VERSION}/denort-${release_arch}.zip"; then
            echo "❌ Failed to download denort binary for $build_arch"
            return 1
        fi
        unzip -o "denort-${release_arch}.zip"
        rm -f "denort-${release_arch}.zip"

        if ! docker build . -f denort_Dockerfile.ubu -t "denort-ubuntu-$dist-$build_arch" \
            --build-arg DENO_VERSION="$DENO_VERSION" \
            --build-arg UBUNTU_DIST="$dist" \
            --build-arg BUILD_VERSION="$BUILD_VERSION" \
            --build-arg FULL_VERSION="$FULL_VERSION" \
            --build-arg ARCH="$build_arch"; then
            echo "❌ Failed to build Docker image for denort $dist on $build_arch"
            rm -f denort
            return 1
        fi

        id="$(docker create "denort-ubuntu-$dist-$build_arch")"
        docker cp "$id:/denort_$FULL_VERSION.deb" - > "./denort_$FULL_VERSION.deb"
        tar -xf "./denort_$FULL_VERSION.deb"
        rm -f denort
    done

    echo "✅ Successfully built for $build_arch"
    return 0
}

if [ "$ARCH" = "all" ]; then
    echo "🚀 Building deno $DENO_VERSION-$BUILD_VERSION for all supported architectures..."
    echo ""

    ARCHITECTURES=("amd64" "arm64")

    for build_arch in "${ARCHITECTURES[@]}"; do
        echo "==========================================="
        echo "Building for architecture: $build_arch"
        echo "==========================================="

        if ! build_architecture "$build_arch"; then
            echo "❌ Failed to build for $build_arch"
            exit 1
        fi

        echo ""
    done

    echo "🎉 All architectures built successfully!"
    echo "Generated packages:"
    ls -la deno_*.deb denort_*.deb
else
    if ! build_architecture "$ARCH"; then
        exit 1
    fi
fi
