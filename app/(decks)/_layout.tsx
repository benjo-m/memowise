import { Stack } from "expo-router";

export default function Layout() {
    return (
        <Stack>
            <Stack.Screen name="index" options={{ title: "Decks" }} />
            <Stack.Screen name="createDeck" options={{ title: "Create deck" }} />
        </Stack>
    )
}