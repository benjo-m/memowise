import { Deck } from "@/models/deck";
import { router } from "expo-router";
import { Text, View } from "react-native";

import colors from "@/styles/colors";
import { StyleSheet, TouchableOpacity } from "react-native";
import CustomButton from "./custom-button";

type DeckCardProps = {
  deck: Deck;
};

export default function DeckCard({ deck }: DeckCardProps) {
  return (
    <TouchableOpacity
      style={styles.card}
      onPress={() => router.navigate({ pathname: "/deck-details", params: { id: deck.id } })}
    >
      <Text style={{ fontSize: 18, fontWeight: 600, color: "#333" }}>{deck.name}</Text>
      <Text style={{ marginTop: 20, marginBottom: 5 }}>Flashcards</Text>
      <View style={{ backgroundColor: "#e7e7e7ff", padding: 10, borderRadius: 10 }}>
        <Text style={{}}>New: {deck.flashcards.filter((card) => card.interval === 0).length}</Text>
        <Text style={{}}>
          To review:
          {
            deck.flashcards.filter(
              (card) =>
                new Date(card.due_date).setHours(0, 0, 0, 0) <= new Date().setHours(0, 0, 0, 0)
            ).length
          }
        </Text>
        <Text style={{}}>Total: {deck.flashcards.length}</Text>
      </View>

      <View style={{ marginTop: 20 }}>
        <CustomButton
          title={"Study"}
          color={colors.blue}
          onPress={() => router.replace({ pathname: "/study", params: { deckId: deck.id } })}
        ></CustomButton>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: "#ffffffff",
    borderWidth: 2,
    borderRadius: 10,
    borderColor: "#e6e6e6ff",
    padding: 16,
    justifyContent: "center",
    alignItems: "center",
    height: "100%",
    marginHorizontal: 10,
  },
});
