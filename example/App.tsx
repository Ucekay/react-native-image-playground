import { Image } from "expo-image";
import { launchImageLibraryAsync } from "expo-image-picker";
import { useState } from "react";
import { Button, StyleSheet, View } from "react-native";
import { launchImagePlaygroundAsync } from "react-native-image-playground";

export default function App() {
  const [url, setUrl] = useState<string | undefined>(undefined);

  const handlePress = async () => {
    const result = await launchImageLibraryAsync({ base64: true });
    if (!result.assets?.[0]?.uri) {
      return;
    }
    console.log("Image Library result", result.assets[0].uri);
    launchImagePlaygroundAsync({
      source:
        "file:///private/var/mobile/Containers/Data/Application/33F27288-9576-4388-906F-A04AD92FDAF9/tmp/PlaygroundImage17-Ksgpyg.heic",
    })
      .then((res) => {
        setUrl(res);
        console.log("Image Playground result", res);
      })
      .catch((err) => {
        console.error("Image Playground error", err);
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
