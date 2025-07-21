import { useSession } from "@/contexts/auth-context";
import { Text, View } from "react-native";

export default function DecksScreen() {
  const { session, signOut } = useSession();

  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Text>Settings screen</Text>
      <Text
        onPress={() => {
          signOut();
        }}
      >
        Sign Out
      </Text>
      <Text
        onPress={() => {
          console.log(session);
        }}
      >
        Get token
      </Text>
    </View>
  );
}
