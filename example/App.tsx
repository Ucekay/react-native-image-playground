import { Image } from "expo-image";
import { useState } from "react";
import { Button, StyleSheet, View } from "react-native";
import { launchImagePlaygroundAsync } from "react-native-image-playground";

export default function App() {
  const [url, setUrl] = useState<string | undefined>(undefined);

  const handlePress = async () => {
    launchImagePlaygroundAsync({ concepts: { text: ["cat", "forest"] } })
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
