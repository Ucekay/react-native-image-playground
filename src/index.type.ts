export interface ImagePlaygroundResult {
  url?: string;
}

export interface ImagePlaygroundModuleType {
  launchImagePlaygroundAsync(): Promise<ImagePlaygroundResult>;
}
