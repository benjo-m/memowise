import { createDeck, getAllDecks } from "@/api/decks";
import { getTodaysProgress } from "@/api/users";
import CustomButton from "@/components/custom-button";
import DeckCard from "@/components/deck-card";
import { useDecks } from "@/contexts/decks-context";
import { useTodaysProgress } from "@/contexts/todays-progress-context";
import colors from "@/styles/colors";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import { useEffect, useState } from "react";
import { ActivityIndicator, Alert, FlatList, Text, View } from "react-native";

export default function DecksScreen() {
  const { decks, setDecks } = useDecks();
  const {
    flashcardsDueTodayCount,
    flashcardsReviewedTodayCount,
    setFlashcardsDueTodayCount,
    setFlashcardsReviewedTodayCount,
  } = useTodaysProgress();
  const [isLoading, setLoading] = useState(true);

  const loadData = async () => {
    const loadedDecks = await getAllDecks();
    setDecks(loadedDecks);

    const loadedTodaysProgress = await getTodaysProgress();
    setFlashcardsDueTodayCount(loadedTodaysProgress.flashcards_due_today_count);
    setFlashcardsReviewedTodayCount(loadedTodaysProgress.flashcards_reviewed_today_count);

    setLoading(false);
  };

  useEffect(() => {
    loadData();
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
        <View style={{ flex: 1, justifyContent: "space-between" }}>
          <View style={{ marginBottom: 20 }}>
            <View style={{ marginBottom: "2%" }}>
              <Text style={{ fontWeight: "600", marginBottom: 10, color: "#313131ff" }}>
                You have {flashcardsDueTodayCount} flashcards scheduled for today
              </Text>
            </View>
            {/* Progress Bar */}
            <View style={{}}>
              <View style={{ backgroundColor: "white", borderRadius: 10, height: 10 }}>
                <View
                  style={{
                    width:
                      flashcardsDueTodayCount == 0
                        ? 0
                        : `${(flashcardsReviewedTodayCount / flashcardsDueTodayCount) * 100}%`,
                    height: "100%",
                    backgroundColor: colors.blue,
                    borderRadius: 10,
                  }}
                />
              </View>
              <Text style={{ fontSize: 12, color: "#555", marginTop: 5, textAlign: "right" }}>
                {flashcardsReviewedTodayCount} / {flashcardsDueTodayCount} reviewed
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
            <View style={{ flex: 1 }}>
              <Text
                style={{ fontSize: 16, fontWeight: "bold", marginBottom: 10, color: "#313131ff" }}
              >
                Decks ({decks.length})
              </Text>
              <FlatList
                data={decks}
                keyExtractor={(item) => item.id.toString()}
                renderItem={({ item }) => <DeckCard deck={item}></DeckCard>}
                style={{ marginBottom: 30, borderRadius: 10 }}
                contentContainerStyle={{ gap: 16 }}
                showsVerticalScrollIndicator={false}
              />
            </View>
          )}
          <CustomButton
            title="Create deck"
            onPress={() => showCreateDeckPrompt("")}
            color={colors.blue}
            icon={<FontAwesome name="plus" size={18} color="white" />}
          />
        </View>
      )}
    </View>
  );
}
