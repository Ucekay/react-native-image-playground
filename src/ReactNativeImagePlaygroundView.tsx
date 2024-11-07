import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ReactNativeImagePlaygroundViewProps } from './ReactNativeImagePlayground.types';

const NativeView: React.ComponentType<ReactNativeImagePlaygroundViewProps> =
  requireNativeViewManager('ReactNativeImagePlayground');

export default function ReactNativeImagePlaygroundView(props: ReactNativeImagePlaygroundViewProps) {
  return <NativeView {...props} />;
}
