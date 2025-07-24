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
    backgroundColor: "#e5f5ffff",
    borderWidth: 2,
    borderRadius: 10,
    padding: 16,
    justifyContent: "center",
    alignItems: "center",
    height: "100%",
    marginHorizontal: 10,
    // marginRight: 20,
  },

  title: {
    fontSize: 18,
    fontWeight: "600",
    color: "#333",
  },
});
