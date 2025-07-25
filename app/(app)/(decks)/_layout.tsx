import { FlashcardsProvider } from "@/contexts/flashcards-context";
import { Stack, usePathname } from "expo-router";

export default function Layout() {
  const pathname = usePathname();

  return (
    <FlashcardsProvider>
      <Stack
        screenOptions={{
          animation:
            pathname.startsWith("/settings") || pathname.startsWith("/stats")
              ? "none"
              : "default",
        }}
      >
        <Stack.Screen
          name="index"
          options={{
            title: "Decks",
          }}
        />
        <Stack.Screen name="create-deck" options={{ title: "Create deck" }} />
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
      </Stack>
    </FlashcardsProvider>
  );
}
