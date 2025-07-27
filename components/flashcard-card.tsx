import { Flashcard } from "@/models/flashcard";
import { FlashcardFreshCreateRequest } from "@/models/flashcard-fresh-create-request";
import { router } from "expo-router";
import { Text, TouchableOpacity } from "react-native";

type FlashcardCardProps = {
  flashcard: Flashcard | FlashcardFreshCreateRequest;
};

export default function FlashcardCard({ flashcard }: FlashcardCardProps) {
  return (
    <TouchableOpacity
      onPress={() =>
        router.navigate({
          pathname: "id" in flashcard ? "/flashcard-details" : "/flashcard-fresh-details",
          params: { front: flashcard.front },
        })
      }
      style={{
        backgroundColor: "#ffff",
        padding: 16,
        marginVertical: 8,
        borderRadius: 12,
        width: "100%",
        alignSelf: "center",
        shadowColor: "#000",
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
        elevation: 2,
      }}
    >
      <Text style={{ fontSize: 16 }}>{flashcard.front}</Text>
    </TouchableOpacity>
  );
}
