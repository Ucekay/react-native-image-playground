import {
  NativeModulesProxy,
  EventEmitter,
  Subscription,
  requireNativeModule,
} from "expo-modules-core";

// Import the native module. On web, it will be resolved to ReactNativeImagePlayground.web.ts
// and on native platforms to ReactNativeImagePlayground.ts

import ReactNativeImagePlaygroundView from "./ReactNativeImagePlaygroundView";

const ImagePlayground = requireNativeModule("ReactNativeImagePlayground");

const launchImagePlayground = async () => {
  return await ImagePlayground.launchImagePlaygroundAsync();
};

// Get the native constant value.

export { ReactNativeImagePlaygroundView, launchImagePlayground };
