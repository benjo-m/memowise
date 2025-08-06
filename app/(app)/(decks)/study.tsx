import CustomButton from "@/components/custom-button";
import { useDecks } from "@/contexts/decks-context";
import { Deck } from "@/models/deck";
import colors from "@/styles/colors";
import { useLocalSearchParams } from "expo-router";
import { useEffect, useState } from "react";
import { ScrollView, Text, View } from "react-native";

export default function StudyScreen() {
  const { deckId } = useLocalSearchParams<{ deckId: string }>();
  const { decks } = useDecks();
  const [deck, setDeck] = useState<Deck | null>(null);
  const [currentFlashcardIndex, setCurrentFlashcardIndex] = useState<number>(0);
  const [answerShown, setAnswerShown] = useState<boolean>(false);

  useEffect(() => {
    if (!deckId) return;

    const foundDeck = decks.find((d) => d.id === Number(deckId)) ?? null;

    if (foundDeck) {
      setDeck(foundDeck);
      // setFlashcards(foundDeck.flashcards);
    }
  }, [decks, deckId]);

  function goToNextFlashcard() {
    if (currentFlashcardIndex < deck.flashcards.length - 1) {
      setCurrentFlashcardIndex((prev) => prev + 1);
    }
    setAnswerShown(false);
  }

  return (
    <View style={{ flex: 1, justifyContent: "space-between", margin: 30 }}>
      {deck ? (
        currentFlashcardIndex == deck.flashcards.length - 1 ? (
          <Text>Study session finished</Text>
        ) : (
          <View style={{ flex: 1 }}>
            <ScrollView style={{ marginBottom: 30 }}>
              <View style={{ borderWidth: 2, borderRadius: 10, padding: 10 }}>
                <Text>{deck.flashcards[currentFlashcardIndex].front}</Text>
              </View>
              <View style={{ marginTop: 10, display: answerShown ? "contents" : "none" }}>
                <Text>Answer:</Text>
                <Text>{deck.flashcards[currentFlashcardIndex].back}</Text>
              </View>
            </ScrollView>
            {answerShown ? (
              <View style={{ flexDirection: "row", justifyContent: "space-between", gap: 10 }}>
                <View style={{ flex: 1 }}>
                  <CustomButton
                    title={"1"}
                    color={colors.blue}
                    onPress={() => {
                      console.log("ocjena: ", 0);
                      goToNextFlashcard();
                    }}
                  ></CustomButton>
                </View>
                <View style={{ flex: 1 }}>
                  <CustomButton
                    title={"2"}
                    color={colors.blue}
                    onPress={() => {
                      console.log("ocjena: ", 0);
                      goToNextFlashcard();
                    }}
                  ></CustomButton>
                </View>
                <View style={{ flex: 1 }}>
                  <CustomButton
                    title={"3"}
                    color={colors.blue}
                    onPress={() => {
                      console.log("ocjena: ", 0);
                      goToNextFlashcard();
                    }}
                  ></CustomButton>
                </View>
                <View style={{ flex: 1 }}>
                  <CustomButton
                    title={"4"}
                    color={colors.blue}
                    onPress={() => {
                      console.log("ocjena: ", 0);
                      goToNextFlashcard();
                    }}
                  ></CustomButton>
                </View>
                <View style={{ flex: 1 }}>
                  <CustomButton
                    title={"5"}
                    color={colors.blue}
                    onPress={() => {
                      console.log("ocjena: ", 0);
                      goToNextFlashcard();
                    }}
                  ></CustomButton>
                </View>
              </View>
            ) : (
              <View>
                <CustomButton
                  title={"Show answer"}
                  color={colors.blue}
                  onPress={() => {
                    setAnswerShown(true);
                  }}
                ></CustomButton>
              </View>
            )}
          </View>
        )
      ) : (
        <Text>Loading...</Text>
      )}
    </View>
  );
}
