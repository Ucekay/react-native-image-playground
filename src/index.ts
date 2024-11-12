import { requireNativeModule } from "expo-modules-core";
import { Platform, Alert } from "react-native";

import {
  ImagePlaygroundModuleType,
  ImagePlaygroundResult,
  ImagePlaygroundConceptOptions,
  ImagePlaygroundSourceImage,
} from "./index.type";

const imagePlaygroundModule = requireNativeModule(
  "ReactNativeImagePlayground",
) as ImagePlaygroundModuleType;

const launchImagePlaygroundAsync = async (
  conceptOptions: ImagePlaygroundConceptOptions,
  sourceImage?: ImagePlaygroundSourceImage,
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
    await imagePlaygroundModule.launchImagePlaygroundAsync(
      conceptOptions,
      sourceImage,
    );
  return res.url;
};

export {
  launchImagePlaygroundAsync,
  type ImagePlaygroundConceptOptions,
  type ImagePlaygroundSourceImage,
};
