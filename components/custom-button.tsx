import colors from "@/styles/colors";
import { StyleSheet, Text, TouchableOpacity, View } from "react-native";

type Props = {
  title: string;
  color: string;
  onPress: () => void;
  icon: any;
};

export default function CustomButton({ title, color, onPress, icon }: Props) {
  return (
    <TouchableOpacity
      style={[styles.button, { backgroundColor: color == "" ? colors.blue : color }]}
      onPress={onPress}
      activeOpacity={0.8}
    >
      <View
        style={{ flexDirection: "row", alignItems: "center", justifyContent: "center", gap: 8 }}
      >
        {icon}
        {title != "" && <Text style={styles.text}>{title}</Text>}
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    backgroundColor: "gray",
    paddingVertical: 13,
    borderRadius: 10,
    alignItems: "center",
  },
  text: {
    color: "#fff",
    fontSize: 16,
    fontWeight: "bold",
  },
});
