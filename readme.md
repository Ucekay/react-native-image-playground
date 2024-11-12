# React Native Image Playground

A React Native/Expo package that integrates Apple Intelligence Image Playground feature into your app.

## Requirements

- iOS 18.1 or later
- iPhone 15 Pro, iPhone 15 Pro Max, or iPhone 16 series
- Currently, a physical device capable of running Image Playground

## Installation

```sh
expo install react-native-ios-image-playground
```

> ⚠️When installing this package in an existing React Native project (not Expo managed project), please follow the guide at the link below
> https://docs.expo.dev/bare/installing-expo-modules/

## Important: Development Setup

⚠️ An Apple Developer Program membership is required for testing on physical devices.

To create and run a development build on your device:
```sh
npx expo prebuild --platform ios --clean
```
```sh
npx expo run:ios
```

## Limitations

- iOS 18.1 or later is required
- Only supported on iPhone 15 Pro, iPhone 15 Pro Max, or iPhone 16 series
- Physical device is required for testing

## Usage

```tsx
import { Image } from "expo-image";
import { useState } from "react";
import { Button, StyleSheet, View } from "react-native";
import { launchImagePlaygroundAsync } from "react-native-image-playground";

export default function App() {
  const [url, setUrl] = useState<string | undefined>(undefined);

  const handlePress = () => {
    launchImagePlaygroundAsync().then((res) => {
      setUrl(res);
    });
  };

  return (
    <View style={styles.container}>
      {url && (
        <View style={styles.imageContainer}>
          <Image source={{ uri: url }} style={styles.image} />
        </View>
      )}
      <Button title="Launch Image Playground" onPress={handlePress} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
  imageContainer: {
    width: 200,
    height: 200,
    borderRadius: 20,
    borderCurve: "continuous",
    overflow: "hidden",
  },
  image: {
    width: "100%",
    height: "100%",
  },
});
```

## API

### `launchImagePlaygroundAsync(params?: ImagePlaygroundParams): Promise<string | undefined>`

Launches the Image Playground and returns the URL of the created image. You can provide optional parameters to customize the behavior.

#### Parameters

`params` - Optional object with the following properties:

- `source`: Source image URL to start editing with
  > ⚠️ Only remote images (http:// or https:// URLs) are supported. Local images (file:// URLs) are not supported.

- `concepts`: Options for AI generation concepts
  - Text-based concepts:
    ```typescript
    {
      text: string | string[]  // Single text or array of texts for concepts
    }
    ```
  - Content-based concepts:
    ```typescript
    {
      title?: string,         // Optional title for the extracted concept
      content: string         // Content to extract concepts from
    }
    ```

#### Examples

Basic usage:
