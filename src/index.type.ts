export interface ImagePlaygroundResult {
  url?: string;
}

export type ImagePlaygroundConceptOptions = {
  type: "text" | "extractedWithTitle";
  content: string | string[];
  title?: string;
};

export type ImagePlaygroundSourceImage = {
  uri: string;
};

export interface ImagePlaygroundModuleType {
  launchImagePlaygroundAsync(
    conceptOptions: ImagePlaygroundConceptOptions,
    sourceImage?: ImagePlaygroundSourceImage,
  ): Promise<ImagePlaygroundResult>;
}
