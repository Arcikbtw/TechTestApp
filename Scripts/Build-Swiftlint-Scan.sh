if mint which swiftlint >/dev/null; then
  mint run swiftlint
else
  echo "warning: SwiftLint not installed, run: mint bootstrap"
fi
