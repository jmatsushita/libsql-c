#!/usr/bin/env sh

set -xe

cargo build --target aarch64-apple-ios --release

rm -rf ../CLibsqlDynamic.xcframework ../CLibsqlDynamic.framework

include_dir=`mktemp -d`

cp ./libsql.h $include_dir/
cp ./dylib/module.modulemap $include_dir/

# Create framework directory structure
mkdir -p CLibsqlDynamic.framework/Headers
cp ./dylib/* CLibsqlDynamic.framework/Headers/
cp ./target/aarch64-apple-ios/release/liblibsql.dylib CLibsqlDynamic.framework/CLibsqlDynamic

# Set the install name
install_name_tool -id @rpath/CLibsqlDynamic.framework/CLibsqlDynamic CLibsqlDynamic.framework/CLibsqlDynamic

# Create the XCFramework
xcodebuild -create-xcframework \
  -framework CLibsqlDynamic.framework \
  -output CLibsqlDynamic.xcframework
