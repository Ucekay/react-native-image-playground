export interface ImagePlaygroundResult {
  url?: string;
}

export type ImagePlaygroundOptions =
  | {
      text: string | string[];
      title?: never;
      content?: never;
    }
  | {
      text?: never;
      title?: string;
      content: string;
    };

export type ImagePlaygroundSourceImage = {
  source: string;
};

export interface ImagePlaygroundParams {
  source?: string;
  concepts?: ImagePlaygroundOptions;
}

export interface ImagePlaygroundModuleType {
  launchImagePlaygroundAsync(
    params: ImagePlaygroundParams,
  ): Promise<ImagePlaygroundResult>;
}
