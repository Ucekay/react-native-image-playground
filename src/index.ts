import { requireNativeModule } from "expo-modules-core";
import { Platform, Alert } from "react-native";

import {
  ImagePlaygroundModuleType,
  ImagePlaygroundResult,
  ImagePlaygroundSourceImage,
  ImagePlaygroundOptions,
  ImagePlaygroundParams,
} from "./index.type";

const imagePlaygroundModule = requireNativeModule(
  "ReactNativeImagePlayground",
) as ImagePlaygroundModuleType;

const launchImagePlaygroundAsync = async (
  params: ImagePlaygroundParams = {},
): Promise<string | undefined> => {
  if (Platform.OS === "android") {
    Alert.alert(
      "Apple Platform Only",
      "This Image Playground feature uses Apple Intelligence and is only available on iOS devices.",
      [{ text: "Close" }],
    );
    return;
  }

  const res: ImagePlaygroundResult =
    await imagePlaygroundModule.launchImagePlaygroundAsync(params);
  return res.url;
};

export {
  launchImagePlaygroundAsync,
  type ImagePlaygroundOptions,
  type ImagePlaygroundSourceImage,
  type ImagePlaygroundParams,
};
