import colors from "@/styles/colors";
import { StyleSheet, Text, TouchableOpacity } from "react-native";

type Props = {
  title: string;
  color: string;
  onPress: () => void;
};

export default function CustomButton({ title, color, onPress }: Props) {
  return (
    <TouchableOpacity
      style={[styles.button, { backgroundColor: color == "" ? colors.blue : color }]}
      onPress={onPress}
      activeOpacity={0.8}
    >
      <Text style={styles.text}>{title}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    backgroundColor: "gray",
    paddingVertical: 10,
    paddingHorizontal: 16,
    borderRadius: 10,
    alignItems: "center",
  },
  text: {
    color: "#fff",
    fontSize: 16,
    fontWeight: "bold",
  },
});
