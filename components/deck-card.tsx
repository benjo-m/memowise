import { Deck } from "@/models/deck";
import colors from "@/styles/colors";
import FontAwesome5 from "@expo/vector-icons/FontAwesome5";
import { router } from "expo-router";
import { StyleSheet, Text, TouchableOpacity, View } from "react-native";
import CustomButton from "./custom-button";

type DeckCardProps = {
  deck: Deck;
};

export default function DeckCard({ deck }: DeckCardProps) {
  const newCount = deck.flashcards.filter((c) => c.interval === 0).length;
  const dueCount = deck.flashcards.filter(
    (c) => new Date(c.due_date).setHours(0, 0, 0, 0) <= new Date().setHours(0, 0, 0, 0)
  ).length;

  return (
    <TouchableOpacity
      style={styles.card}
      onPress={() => router.navigate({ pathname: "/deck-details", params: { id: deck.id } })}
      activeOpacity={0.8}
    >
      <Text style={styles.title} numberOfLines={2} ellipsizeMode="tail">
        {deck.name}
      </Text>

      <View style={styles.statsContainer}>
        <View style={styles.stat}>
          <Text style={styles.statLabel}>New flashcards</Text>
          <Text style={styles.statValue}>{newCount}</Text>
        </View>
        <View style={styles.stat}>
          <Text style={styles.statLabel}>Flashcards to review</Text>
          <Text style={styles.statValue}>{dueCount}</Text>
        </View>
        <View style={styles.stat}>
          <Text style={styles.statLabel}>Total flashcards</Text>
          <Text style={styles.statValue}>{deck.flashcards.length}</Text>
        </View>
      </View>
      <View style={{ width: "100%" }}>
        <CustomButton
          title="Study"
          color={colors.blue}
          onPress={() => router.push({ pathname: "/study", params: { deckId: deck.id } })}
          icon={<FontAwesome5 name="play" size={18} color="white" />}
        />
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    flex: 1,
    backgroundColor: "#fff",
    borderRadius: 14,
    padding: 20,
    marginHorizontal: 8,
    justifyContent: "space-between",
    alignItems: "center",
  },
  title: {
    fontSize: 20,
    fontWeight: "700",
    color: "#111",
    textAlign: "center",
  },
  statsContainer: {
    justifyContent: "space-between",
    width: "100%",
    gap: 15,
    borderRadius: 10,
  },
  stat: {
    alignItems: "center",
  },
  statLabel: {
    fontSize: 14,
    color: "#555",
    marginBottom: 2,
  },
  statValue: {
    fontSize: 16,
    fontWeight: "600",
    color: "#222",
  },
});
