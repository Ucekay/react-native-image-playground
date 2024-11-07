import { StyleSheet, Text, View } from "react-native";
import * as ReactNativeImagePlayground from "react-native-image-playground";

export default function App() {
  return (
    <View style={styles.container}>
      <ReactNativeImagePlayground.ReactNativeImagePlaygroundView />
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
});
