import { Text, TouchableOpacity } from "react-native";

type FlashcardCardProps = {
  front: string;
  onPress?: () => void;
};

export default function FlashcardCard({ front, onPress }: FlashcardCardProps) {
  return (
    <TouchableOpacity
      onPress={onPress}
      style={{
        backgroundColor: "#ffff",
        padding: 16,
        marginVertical: 8,
        borderRadius: 12,
        width: "90%",
        alignSelf: "center",
        shadowColor: "#000",
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
        elevation: 2, // for Android shadow
      }}
    >
      <Text style={{ fontSize: 16 }}>{front}</Text>
    </TouchableOpacity>
  );
}
