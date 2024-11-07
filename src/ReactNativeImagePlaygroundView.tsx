import { requireNativeViewManager } from "expo-modules-core";
import * as React from "react";

const NativeView: React.ComponentType = requireNativeViewManager(
  "ReactNativeImagePlayground",
);

export default function ReactNativeImagePlaygroundView() {
  return <NativeView />;
}
