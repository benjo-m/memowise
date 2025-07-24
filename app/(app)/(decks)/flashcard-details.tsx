import { getFlashcardById } from "@/api/flashcards";
import { Flashcard } from "@/models/flashcard";
import { useLocalSearchParams } from "expo-router";
import { useEffect, useState } from "react";
import { ActivityIndicator, Text, View } from "react-native";

export default function FlashcardDetails() {
  const { id } = useLocalSearchParams<{ id: string }>();

  const [flashcard, setFlashcard] = useState<Flashcard | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchFlashcard = async () => {
      try {
        const res = await getFlashcardById(id);
        setFlashcard(res);
      } catch (e) {
        console.error(e);
        setError("Failed to load flashcard.");
      } finally {
        setLoading(false);
      }
    };

    fetchFlashcard();
  }, [id]);

  return (
    <View style={{ flex: 1, alignItems: "center", margin: 30 }}>
      {loading ? (
        <ActivityIndicator />
      ) : error ? (
        <Text>{error}</Text>
      ) : flashcard ? (
        <>
          <Text>Front: {flashcard.front}</Text>
          <Text>Back: {flashcard.back}</Text>
        </>
      ) : (
        <Text>Flashcard not found.</Text>
      )}
    </View>
  );
}
