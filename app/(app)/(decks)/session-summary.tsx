import CustomButton from "@/components/custom-button";
import { router } from "expo-router";
import { Text, View } from "react-native";

export default function SessionSummaryScreen() {
  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center", margin: 30 }}>
      <Text>Session finished</Text>
      <CustomButton
        title={"Finish"}
        color={""}
        onPress={() => router.replace("/(app)/(decks)")}
      ></CustomButton>
    </View>
  );
}
