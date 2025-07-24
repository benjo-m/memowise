import { getAllDecks } from "@/api/decks";
import CustomButton from "@/components/custom-button";
import DecksCarousel from "@/components/decks-carousel";
import { useDecks } from "@/contexts/decks-context";
import { router } from "expo-router";
import { useEffect, useState } from "react";
import { ActivityIndicator, StyleSheet, Text, View } from "react-native";

export default function DecksScreen() {
  const { decks, setDecks } = useDecks();
  const [isLoading, setLoading] = useState(true);

  useEffect(() => {
    const loadDecks = async () => {
      const data = await getAllDecks();
      setDecks(data);
      setLoading(false);
    };

    if (decks.length === 0) {
      loadDecks();
    } else {
      setLoading(false);
    }
  }, []);

  return (
    <View style={{ flex: 1, margin: 30 }}>
      {isLoading ? (
        <ActivityIndicator style={{ flex: 1 }} />
      ) : (
        <View style={{ flex: 1, justifyContent: "space-between", gap: "10%" }}>
          <View
            style={{
              flexDirection: "row",
              justifyContent: "space-between",
              gap: "8%",
            }}
          >
            <View style={styles.box}>
              <Text style={styles.boxHeading}>Study streak</Text>
              <Text style={styles.boxNumber}>10</Text>
            </View>
            <View style={styles.box}>
              <Text style={styles.boxHeading}>Heading 2</Text>
              <Text style={styles.boxNumber}>23</Text>
            </View>
            <View style={styles.box}>
              <Text style={styles.boxHeading}>Heading 3</Text>
              <Text style={styles.boxNumber}>92</Text>
            </View>
          </View>
          <DecksCarousel decks={decks} />
          <CustomButton
            title="New deck"
            onPress={() => router.navigate("/create-deck")}
            color={""}
          />
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  box: {
    flex: 1,
    alignItems: "center",
    borderWidth: 2,
    borderRadius: 10,
    borderColor: "#000",
    paddingVertical: 12,
  },
  boxHeading: {
    fontSize: 13,
  },
  boxNumber: {
    fontWeight: "bold",
    fontSize: 18,
    marginTop: 4,
  },
});
