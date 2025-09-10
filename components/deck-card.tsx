import { Deck } from "@/models/deck";
import FontAwesome5 from "@expo/vector-icons/FontAwesome5";
import { router } from "expo-router";
import { StyleSheet, Text, TouchableOpacity, View } from "react-native";

type DeckCardProps = {
  deck: Deck;
};

export default function DeckCard({ deck }: DeckCardProps) {
  const newCount = deck.flashcards.filter((fc) => fc.interval === 0).length;
  const dueCount = deck.flashcards.filter((fc) => fc.due_today).length;

  const studyButton = () => {
    return (
      <TouchableOpacity
        style={{
          flexDirection: "row",
          backgroundColor: "#34d770ff",
          paddingVertical: 12,
          paddingHorizontal: 10,
          borderRadius: 10,
          justifyContent: "center",
          alignItems: "center",
          gap: 6,
        }}
        onPress={() => router.replace({ pathname: "/study", params: { deckId: deck.id } })}
      >
        <FontAwesome5 name="play" size={14} color="white" />
        <Text style={{ color: "white", fontWeight: "bold" }}>Study</Text>
      </TouchableOpacity>
    );
  };

  return (
    <TouchableOpacity
      style={styles.card}
      onPress={() => router.navigate({ pathname: "/deck-details", params: { id: deck.id } })}
      activeOpacity={0.8}
    >
      <View>
        <Text style={styles.title}>
          {deck.name.length > 20 ? deck.name.slice(0, 20) + "…" : deck.name}
        </Text>
        <View style={styles.statsContainer}>
          <View style={styles.stat}>
            <Text style={styles.statLabel}>New cards</Text>
            <Text style={styles.statValue}>{newCount}</Text>
          </View>
          <View style={styles.stat}>
            <Text style={styles.statLabel}>To review</Text>
            <Text style={styles.statValue}>{dueCount}</Text>
          </View>
        </View>
      </View>
      {studyButton()}
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    flex: 1,
    flexDirection: "row",
    backgroundColor: "#fff",
    borderRadius: 10,
    justifyContent: "space-between",
    paddingVertical: 14,
    paddingHorizontal: 10,
  },
  title: {
    fontSize: 16,
    fontWeight: "700",
    color: "#111",
    marginBottom: 4,
  },
  statsContainer: {
    flexDirection: "row",
    gap: 10,
  },
  stat: {
    flexDirection: "row",
    gap: 4,
  },
  statLabel: {
    fontSize: 12,
    color: "#555",
  },
  statValue: {
    fontWeight: "600",
    fontSize: 12,
    color: "#222",
  },
});
