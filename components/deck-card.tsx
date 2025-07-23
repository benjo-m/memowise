import { Text } from "react-native";

import { StyleSheet, TouchableOpacity } from "react-native";

type DeckCardProps = {
  name: string;
  onPress?: () => void;
};

export default function DeckCard({ name, onPress }: DeckCardProps) {
  return (
    <TouchableOpacity style={styles.card} onPress={onPress}>
      <Text style={styles.title}>{name}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: "#fff",
    borderRadius: 12,
    padding: 16,
    elevation: 3, // Android shadow
    shadowColor: "#000", // iOS shadow
    shadowOpacity: 0.1,
    shadowRadius: 6,
    shadowOffset: { width: 0, height: 2 },
  },
  title: {
    fontSize: 18,
    fontWeight: "600",
    color: "#333",
  },
});
