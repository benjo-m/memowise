import { Flashcard } from "@/models/flashcard";
import { router } from "expo-router";
import { Text, TouchableOpacity } from "react-native";

type FlashcardCardProps = {
  flashcard: Flashcard;
};

export default function FlashcardCard({ flashcard }: FlashcardCardProps) {
  return (
    <TouchableOpacity
      onPress={() =>
        router.navigate({
          pathname: "/flashcard-details",
          params: { id: flashcard.id },
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
