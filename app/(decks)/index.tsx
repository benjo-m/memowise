import { Link } from "expo-router";
import { Button, Text, View } from "react-native";

export default function DecksScreen() {
    return (
        <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
            <Text>Decks screen</Text>
            <Link href="/create" asChild>
                <Button title={"Create deck"} />
            </Link>
        </View>
    )
}