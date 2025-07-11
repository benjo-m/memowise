import { Stack } from "expo-router";

export default function Layout() {
  return (
    <Stack>
      <Stack.Screen name="index" options={{ title: "Decks" }} />
      <Stack.Screen name="create-deck" options={{ title: "Create deck" }} />
    </Stack>
  );
}
