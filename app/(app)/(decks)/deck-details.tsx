import { getDeckById } from "@/api/decks";
import FlashcardCard from "@/components/flashcard-card";
import { Deck } from "@/models/deck";
import { useLocalSearchParams } from "expo-router";
import { useEffect, useState } from "react";
import { ActivityIndicator, Text, View } from "react-native";

export default function DeckDetailsScreen() {
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
    <View style={{ flex: 1, alignItems: "center" }}>
      {loading ? (
        <ActivityIndicator />
      ) : error ? (
        <Text>{error}</Text>
      ) : deck ? (
        <>
          <Text style={{ fontSize: 24, marginBottom: 20 }}>{deck.name}</Text>
          {deck.flashcards.map((flashcard) => (
            <FlashcardCard key={flashcard.id} front={flashcard.front} />
          ))}
        </>
      ) : (
        <Text>Deck not found.</Text>
      )}
    </View>
  );
}
