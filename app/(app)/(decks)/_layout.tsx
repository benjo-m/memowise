import { Stack, usePathname } from "expo-router";

export default function Layout() {
  const pathname = usePathname();

  return (
    <Stack
      screenOptions={{
        animation:
          pathname.startsWith("/settings") || pathname.startsWith("/stats") ? "none" : "default",
      }}
    >
      <Stack.Screen
        name="index"
        options={{
          title: "Decks",
        }}
      />
      <Stack.Screen name="deck-details" options={{ title: "Deck details" }} />
      <Stack.Screen
        name="add-flashcards"
        options={{
          title: "Add flashcards",
          headerBackButtonDisplayMode: "generic",
        }}
      />
      <Stack.Screen
        name="flashcard-details"
        options={{
          title: "Flashcard details",
          headerBackButtonDisplayMode: "generic",
        }}
      />
      <Stack.Screen name="study" options={{ title: "Study", headerBackTitle: "Quit session" }} />
      <Stack.Screen name="session-summary" options={{ title: "Session summary" }} />
    </Stack>
  );
}
