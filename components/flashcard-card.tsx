import { deleteFlashcard } from "@/api/flashcards";
import { useDecks } from "@/contexts/decks-context";
import { useTodaysProgress } from "@/contexts/todays-progress-context";
import { Flashcard } from "@/models/flashcard";
import Ionicons from "@expo/vector-icons/Ionicons";
import { router } from "expo-router";
import { Alert, Text, TouchableOpacity } from "react-native";

type FlashcardCardProps = {
  flashcard: Flashcard;
};

export default function FlashcardCard({ flashcard }: FlashcardCardProps) {
  const { setDecks } = useDecks();
  const { setFlashcardsDueTodayCount } = useTodaysProgress();

  const handleDeleteFlashcard = async (flashcard: Flashcard) => {
    try {
      if (flashcard.due_today) {
        setFlashcardsDueTodayCount((prev) => prev - 1);
      }
      await deleteFlashcard(flashcard.id);
      setDecks((prevDecks) =>
        prevDecks.map((deck) =>
          deck.id === flashcard.deck_id
            ? {
                ...deck,
                flashcards: deck.flashcards.filter((c) => c.id !== flashcard.id),
              }
            : deck
        )
      );
    } catch (err) {
      err instanceof Error && Alert.alert("Failed to delete flashcard", err.message);
    }
  };

  return (
    <TouchableOpacity
      onPress={() => {
        router.navigate({
          pathname: "/flashcard-details",
          params: { flashcardId: flashcard.id, deckId: flashcard.deck_id },
        });
      }}
      style={{
        flexDirection: "row",
        justifyContent: "space-between",
        alignItems: "center",
        backgroundColor: "#ffff",
        padding: 14,
        borderRadius: 12,
        width: "100%",
        alignSelf: "center",
      }}
    >
      <Text style={{ fontSize: 16 }} numberOfLines={1}>
        {flashcard.front.length > 20 ? flashcard.front.slice(0, 25) + "..." : flashcard.front}
      </Text>
      <TouchableOpacity onPress={async () => handleDeleteFlashcard(flashcard)}>
        <Ionicons name="remove-circle" size={28} color="#f25c5cff" />
      </TouchableOpacity>
    </TouchableOpacity>
  );
}
