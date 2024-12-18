# React Native Image Playground

A React Native/Expo package that integrates **Image Playground** feature into your app.
**Image Playground** is one of the features introduced in iOS 18.2 as part of Apple Intelligence, allowing users to generate images using AI. This package wraps the **Image Playground API** and enables seamless integration into React Native apps.

For more details about Apple's Intelligence framework and Image Playground, refer to the following resources:
-  [Apple Intelligence Overview](https://developer.apple.com/apple-intelligence/)
-  [Image Playground Framework Documentation](https://developer.apple.com/documentation/imageplayground)

## Requirements

- iOS 18.2 or later
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

- iOS 18.2 +
- Only supported on iPhone 15 Pro, iPhone 15 Pro Max, or iPhone 16 series
- Physical device is required for testing

## Baisc Usage

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

```tsx
// Text-based concepts example
const handleTextConcepts = async () => {
  const result = await launchImagePlaygroundAsync({
    concepts: {
      text: ["sunset at beach", "tropical paradise"]
    }
  });
  // Handle result
};

// Content-based concepts example
const handleContentConcepts = async () => {
  const result = await launchImagePlaygroundAsync({
    concepts: {
      title: "Summer Vacation",
      content: "A beautiful day at the beach with crystal clear water and white sand. Palm trees swaying in the warm breeze."
    }
  });
  // Handle result
};

// Example with source image
const handleWithSource = async () => {
  const result = await launchImagePlaygroundAsync({
    source: "https://example.com/beach.jpg",
    concepts: {
      text: "enhance sunset colors"
    }
  });
  // Handle result
};
```


