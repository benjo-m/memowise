import colors from "@/styles/colors";
import { router } from "expo-router";
import React from "react";
import { Text, View } from "react-native";
import CustomButton from "./custom-button";

type Props = {
  message?: string;
  suggestion?: string;
  onBack?: () => void;
};

export default function FallbackMessage({
  message = "Something went wrong.",
  suggestion = "Restart the app and try again.",
  onBack = () => router.back(),
}: Props) {
  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center", padding: 20 }}>
      <Text style={{ fontSize: 18, textAlign: "center", marginBottom: 10 }}>{message}</Text>
      <Text style={{ fontSize: 14, textAlign: "center", color: "gray", marginBottom: 20 }}>
        {suggestion}
      </Text>
      {onBack && <CustomButton title="Go Back" color={colors.blue} onPress={onBack} />}
    </View>
  );
}
