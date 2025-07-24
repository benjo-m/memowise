import { Deck } from "@/models/deck";
import { router } from "expo-router";
import { Text } from "react-native";

import { StyleSheet, TouchableOpacity } from "react-native";

type DeckCardProps = {
  deck: Deck;
};

export default function DeckCard({ deck }: DeckCardProps) {
  return (
    <TouchableOpacity
      style={styles.card}
      onPress={() =>
        router.navigate({ pathname: "/deck-details", params: { id: deck.id } })
      }
    >
      <Text style={styles.title}>{deck.name}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: "#ffffffff",
    borderWidth: 2,
    borderRadius: 10,
    padding: 16,
    justifyContent: "center",
    alignItems: "center",
    height: "100%",
    marginHorizontal: 10,
  },

  title: {
    fontSize: 18,
    fontWeight: "600",
    color: "#333",
  },
});
