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

### `launchImagePlaygroundAsync(): Promise<string | undefined>`

Launches the Image Playground and returns the URL of the created image.

```typescript
import { launchImagePlaygroundAsync } from "react-native-image-playground";

const handlePress = async () => {
  const url = await launchImagePlaygroundAsync();
};
```