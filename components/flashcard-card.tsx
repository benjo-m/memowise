import { deleteFlashcard } from "@/api/flashcards";
import { useDecks } from "@/contexts/decks-context";
import { Flashcard } from "@/models/flashcard";
import Ionicons from "@expo/vector-icons/Ionicons";
import { router } from "expo-router";
import { Alert, Text, TouchableOpacity } from "react-native";

type FlashcardCardProps = {
  flashcard: Flashcard;
};

export default function FlashcardCard({ flashcard }: FlashcardCardProps) {
  const { setDecks } = useDecks();

  const handleDeleteFlashcard = async (flashcard: Flashcard) => {
    try {
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
        marginVertical: 8,
        borderRadius: 12,
        width: "100%",
        alignSelf: "center",
      }}
    >
      <Text style={{ fontSize: 16 }}>{flashcard.front}</Text>
      <TouchableOpacity onPress={async () => handleDeleteFlashcard(flashcard)}>
        <Ionicons name="remove-circle" size={28} color="#f25c5cff" />
      </TouchableOpacity>
    </TouchableOpacity>
  );
}
