import { requireNativeModule } from "expo-modules-core";

import { ImagePlaygroundModuleType, ImagePlaygroundResult } from "./index.type";

const imagePlaygroundModule = requireNativeModule(
  "ReactNativeImagePlayground",
) as ImagePlaygroundModuleType;

const launchImagePlaygroundAsync = async (): Promise<string | undefined> => {
  const res: ImagePlaygroundResult =
    await imagePlaygroundModule.launchImagePlaygroundAsync();
  return res.url;
};

export { launchImagePlaygroundAsync };
