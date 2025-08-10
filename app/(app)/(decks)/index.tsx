import { createDeck, getAllDecks } from "@/api/decks";
import CustomButton from "@/components/custom-button";
import DecksCarousel from "@/components/decks-carousel";
import { useDecks } from "@/contexts/decks-context";
import colors from "@/styles/colors";
import { useEffect, useState } from "react";
import { ActivityIndicator, Alert, StyleSheet, Text, View } from "react-native";

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

  const showCreateDeckPrompt = (defaultText: string) => {
    Alert.prompt(
      "Create deck",
      "Enter a name for your new deck",
      [
        {
          text: "Cancel",
          style: "cancel",
        },
        {
          text: "Create",
          isPreferred: true,
          onPress: async (name) => handleCreateDeck(name),
        },
      ],
      "plain-text",
      defaultText
    );
  };

  const handleCreateDeck = async (name: string | undefined) => {
    if (name === undefined) return;

    const trimmedName = name.trim();
    const duplicate = decks.some((deck) => deck.name === trimmedName);
    if (!name || trimmedName === "") {
      Alert.alert("Name required", "Please enter a deck name.", [
        {
          text: "OK",
          onPress: () => {
            showCreateDeckPrompt("");
          },
        },
      ]);
    } else if (duplicate) {
      Alert.alert("Duplicate", "Deck with that name already exists.", [
        {
          text: "OK",
          onPress: () => {
            showCreateDeckPrompt(name);
          },
        },
      ]);
    } else {
      try {
        const newDeck = await createDeck(trimmedName);
        setDecks([newDeck, ...decks]);
      } catch (err) {
        err instanceof Error && Alert.alert("Failed to create deck", err.message);
      }
    }
  };

  return (
    <View style={{ flex: 1, margin: 30 }}>
      {isLoading ? (
        <ActivityIndicator style={{ flex: 1 }} />
      ) : (
        <View style={{ flex: 1, justifyContent: "space-between", gap: "13%" }}>
          <View
            style={{
              flexDirection: "row",
              justifyContent: "space-between",
              gap: "5%",
            }}
          >
            <View style={styles.box}>
              <Text style={styles.boxHeading}>Study streak</Text>
              <Text style={styles.boxNumber}>10</Text>
            </View>
            <View style={styles.box}>
              <Text style={styles.boxHeading}>Due flashcards</Text>
              <Text style={styles.boxNumber}>23</Text>
            </View>
            <View style={styles.box}>
              <Text style={styles.boxHeading}>Heading 3</Text>
              <Text style={styles.boxNumber}>92</Text>
            </View>
          </View>
          <DecksCarousel decks={decks} />
          <CustomButton
            title="Create deck"
            onPress={() => showCreateDeckPrompt("")}
            color={colors.blue}
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
    borderRadius: 10,
    paddingVertical: 12,
    backgroundColor: "#ffffff",
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
