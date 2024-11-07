import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ReactNativeImagePlayground.web.ts
// and on native platforms to ReactNativeImagePlayground.ts
import ReactNativeImagePlaygroundModule from './ReactNativeImagePlaygroundModule';
import ReactNativeImagePlaygroundView from './ReactNativeImagePlaygroundView';
import { ChangeEventPayload, ReactNativeImagePlaygroundViewProps } from './ReactNativeImagePlayground.types';

// Get the native constant value.
export const PI = ReactNativeImagePlaygroundModule.PI;

export function hello(): string {
  return ReactNativeImagePlaygroundModule.hello();
}

export async function setValueAsync(value: string) {
  return await ReactNativeImagePlaygroundModule.setValueAsync(value);
}

const emitter = new EventEmitter(ReactNativeImagePlaygroundModule ?? NativeModulesProxy.ReactNativeImagePlayground);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { ReactNativeImagePlaygroundView, ReactNativeImagePlaygroundViewProps, ChangeEventPayload };
