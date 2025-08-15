import { createDeck, getAllDecks } from "@/api/decks";
import CustomButton from "@/components/custom-button";
import DecksCarousel from "@/components/decks-carousel";
import { useDecks } from "@/contexts/decks-context";
import colors from "@/styles/colors";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import { useEffect, useState } from "react";
import { ActivityIndicator, Alert, RefreshControl, ScrollView, Text, View } from "react-native";

export default function DecksScreen() {
  const { decks, setDecks } = useDecks();
  const [isLoading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  const loadDecks = async () => {
    const data = await getAllDecks();
    setDecks(data);
    setLoading(false);
  };

  useEffect(() => {
    loadDecks();
  }, []);

  const onRefresh = async () => {
    setRefreshing(true);
    await loadDecks();
    setRefreshing(false);
  };

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

  const getTotalFlashcards = () => {
    const today = new Date();
    today.setHours(0, 0, 0, 0); // normalize to midnight

    return decks.reduce((sum, deck) => {
      const dueFlashcards = deck.flashcards.filter((card) => {
        const dueDate = new Date(card.due_date);
        dueDate.setHours(0, 0, 0, 0);
        return dueDate <= today;
      });
      return sum + dueFlashcards.length;
    }, 0);
  };

  return (
    <ScrollView
      contentContainerStyle={{ flexGrow: 1, marginVertical: 20, marginHorizontal: 30 }}
      refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} />}
    >
      {isLoading ? (
        <ActivityIndicator style={{ flex: 1 }} />
      ) : (
        <View style={{ flex: 1, justifyContent: "space-between", gap: "10%" }}>
          <View>
            <View style={{ marginBottom: "5%" }}>
              <Text style={{ fontSize: 20, fontWeight: "700", color: "#111" }}>
                Friendly greeting
              </Text>
              <Text style={{ fontSize: 14, color: "#555", marginTop: 5 }}>
                You have {getTotalFlashcards()} flashcards scheduled for today
              </Text>
            </View>
            {/* Progress Bar */}
            <View style={{}}>
              <View style={{ backgroundColor: "white", borderRadius: 10, height: 10 }}>
                <View
                  style={{
                    width: `${(1 / getTotalFlashcards()) * 100}%`,
                    height: "100%",
                    backgroundColor: colors.blue,
                    borderRadius: 10,
                  }}
                />
              </View>
              <Text style={{ fontSize: 12, color: "#555", marginTop: 5, textAlign: "right" }}>
                {2} / {getTotalFlashcards()} reviewed
              </Text>
            </View>
          </View>
          {decks.length === 0 ? (
            <View
              style={{
                flex: 1,
                justifyContent: "center",
                alignItems: "center",
                padding: 20,
              }}
            >
              <Text style={{ fontSize: 18, fontWeight: "600", color: "#333", marginBottom: 6 }}>
                You don't have any decks
              </Text>
              <Text style={{ fontSize: 14, color: "#666", textAlign: "center", marginBottom: 12 }}>
                Create a deck by pressing the{" "}
                <Text style={{ fontWeight: "700", color: "#6b6b6bff" }}>Create deck</Text> button to
                start studying.
              </Text>
            </View>
          ) : (
            <DecksCarousel decks={decks} />
          )}
          <CustomButton
            title="Create deck"
            onPress={() => showCreateDeckPrompt("")}
            color={colors.blue}
            icon={<FontAwesome name="plus" size={20} color="white" />}
          />
        </View>
      )}
    </ScrollView>
  );
}
