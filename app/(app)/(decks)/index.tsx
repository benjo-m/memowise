import { getAllDecks } from "@/api/decks";
import DeckCard from "@/components/deck-card";
import { useDecks } from "@/contexts/decks-context";
import { router } from "expo-router";
import { useEffect, useState } from "react";
import { ActivityIndicator, Button, FlatList, View } from "react-native";

export default function DecksScreen() {
  const { decks, setDecks } = useDecks();
  const [isLoading, setLoading] = useState(true);

  useEffect(() => {
    const loadDecks = async () => {
      const data = await getAllDecks();
      setDecks(data);
      setLoading(false);
    };

    if (decks.length === 0) {
      loadDecks();
    } else {
      setLoading(false);
    }
  }, []);

  return (
    <View style={{ flex: 1 }}>
      {isLoading ? (
        <ActivityIndicator style={{ flex: 1 }} />
      ) : (
        <View>
          <View style={{ height: "85%" }}>
            <FlatList
              data={decks}
              keyExtractor={({ id }) => id}
              renderItem={({ item }) => <DeckCard name={item.name} />}
            />
          </View>
          <Button
            title="Create deck"
            onPress={() => router.push("/create-deck")}
          />
        </View>
      )}
    </View>
  );
}
