import { Image } from "expo-image";
import React, { useState } from "react";
import { Button, KeyboardAvoidingView, ScrollView, StyleSheet, TextInput, View, Text} from "react-native";
import { launchImagePlaygroundAsync } from "react-native-image-playground";

const TITLE = 'The Guiding Light';
const CONTENT = 'A foggy, mysterious forest with a glowing girl as the guide. Her golden light illuminates the mist, flowers bloom at her feet, and an ancient door stands in the distance. A magical, ethereal atmosphere.'

export default function App() {
  const [url, setUrl] = useState<string | undefined>(undefined);
  const [concepts, setConcepts] = useState<string | undefined>('');

  const handlePress = async () => {
    launchImagePlaygroundAsync()
      .then((res) => {
        setUrl(res);
      })
      .catch((err) => {
        console.error("Image Playground error", err);
      });
  };

  const handleLaunchWithConcept = async () => {
    if (!concepts) return;
    launchImagePlaygroundAsync({concepts: { text: concepts }})
      .then((res) => {
        setUrl(res);
      })
      .catch((err) => {
        console.error("Image Playground error", err);
      });
  }

  const handleLaunchWithTitle = async () => {
    launchImagePlaygroundAsync({concepts: { title: TITLE, content: CONTENT }})
      .then((res) => {
        setUrl(res);
      })
      .catch((err) => {
        console.error("Image Playground error", err);
      });
  }

  return (
    <View style={styles.wrapper}>
      <KeyboardAvoidingView behavior="padding" style={styles.container}>
      {url && (
        <View style={styles.imageContainer}>
          <Image source={{ uri: url }} style={styles.image} />
        </View>
      )}
        <Button title="Launch Image Playground" onPress={handlePress} />
        {/*<TextInput value={concepts} onChangeText={setConcepts} placeholder="Concept" style={styles.inputContainer} />
        <Button title="Launch Image Playground with Concepts" onPress={handleLaunchWithConcept} />
        <View>
          <Text style={{ fontSize:21 }}>title: {TITLE}</Text>
          <Text style={{fontSize:17}}>content: </Text><Text style={{fontSize:17}}>{CONTENT}</Text>
        </View>
        <Button title="Launch Image Playground with Title and Content" onPress={handleLaunchWithTitle} />*/}
      </KeyboardAvoidingView>
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: {
    flex: 1,
    backgroundColor: "#fff",
  },
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
    paddingHorizontal: 20,
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
  inputContainer: {
    width: '100%',
    borderColor: "gray",
    borderWidth: 1,
    borderRadius: 10,
    borderCurve: "continuous",
    marginVertical: 10,
    padding: 10,
  },
});
