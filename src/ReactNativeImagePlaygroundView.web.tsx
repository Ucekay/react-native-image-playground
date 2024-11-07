import * as React from 'react';

import { ReactNativeImagePlaygroundViewProps } from './ReactNativeImagePlayground.types';

export default function ReactNativeImagePlaygroundView(props: ReactNativeImagePlaygroundViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
