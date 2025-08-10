import CustomButton from "@/components/custom-button";
import { useSession } from "@/contexts/auth-context";
import { inputStyles } from "@/styles/inputs";
import { Alert, ScrollView, Text, TextInput, View } from "react-native";

export default function SettingsScreen() {
  const { session, signOut } = useSession();

  return (
    <ScrollView style={{ flex: 1, margin: 30 }}>
      <View style={{ marginBottom: 30 }}>
        <Text style={{ fontSize: 18, fontWeight: 600, marginBottom: 15 }}>Account</Text>
        <View style={{ marginBottom: 15 }}>
          <Text style={{ marginBottom: 5 }}>Email</Text>
          <TextInput
            style={inputStyles.base}
            autoCapitalize="none"
            autoComplete="off"
            autoCorrect={false}
            value="email@email.com"
            editable={false}
          />
        </View>
        <View>
          <CustomButton
            title={"Edit account"}
            color={""}
            onPress={function (): void {
              throw new Error("Function not implemented.");
            }}
          ></CustomButton>
        </View>
      </View>
      <View style={{ marginBottom: 30 }}>
        <Text style={{ fontSize: 18, fontWeight: 600, marginBottom: 15 }}>Theme</Text>
      </View>
      <CustomButton
        title={"Sign out"}
        color={"#bcbcbcff"}
        onPress={() => {
          Alert.alert(
            "Sign out",
            "Are you sure you want to sign out?",
            [
              { text: "No", style: "cancel" },
              { text: "Yes", onPress: () => signOut() },
            ],
            { cancelable: true }
          );
        }}
      ></CustomButton>
      <CustomButton
        title={"Get token"}
        color={""}
        onPress={() => console.log(session)}
      ></CustomButton>
    </ScrollView>
  );
}
