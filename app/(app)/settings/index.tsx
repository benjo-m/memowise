import { useSession } from "@/contexts/auth-context";
import { Text, View } from "react-native";

export default function DecksScreen() {
  const { session, signOut } = useSession();

  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Text>Settings screen</Text>
      <Text
        onPress={() => {
          // The `app/(app)/_layout.tsx` will redirect to the sign-in screen.
          signOut();
        }}
      >
        Sign Out
      </Text>
      <Text
        onPress={() => {
          // const res = JSON.parse(session!);
          console.log(session);
        }}
      >
        Get token
      </Text>
    </View>
  );
}
