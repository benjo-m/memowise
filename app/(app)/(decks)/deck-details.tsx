import { getDeckById } from "@/api/decks";
import { Deck } from "@/models/deck";
import { useLocalSearchParams } from "expo-router";
import { useEffect, useState } from "react";
import { ActivityIndicator, Text, View } from "react-native";

export default function DeckDetails() {
  const { id } = useLocalSearchParams<{ id: string }>();

  const [deck, setDeck] = useState<Deck | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchDeck = async () => {
      try {
        const res = await getDeckById(id);
        setDeck(res);
      } catch (e) {
        console.error(e);
        setError("Failed to load deck.");
      } finally {
        setLoading(false);
      }
    };

    fetchDeck();
  }, [id]);

  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      {loading ? (
        <ActivityIndicator />
      ) : error ? (
        <Text>{error}</Text>
      ) : deck ? (
        <>
          <Text style={{ fontSize: 24 }}>{deck.name}</Text>
          {/* You can show more deck details here */}
        </>
      ) : (
        <Text>Deck not found.</Text>
      )}
    </View>
  );
}
