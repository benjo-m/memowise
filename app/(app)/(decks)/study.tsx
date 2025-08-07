import { updateFlashcardStats } from "@/api/flashcards";
import CustomButton from "@/components/custom-button";
import FallbackMessage from "@/components/fallback-message";
import { useDecks } from "@/contexts/decks-context";
import { applySm2 } from "@/helpers/sm2";
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
    }
  }, [decks, deckId]);

  const goToNextFlashcard = () => {
    if (currentFlashcardIndex < deck!.flashcards.length) {
      setCurrentFlashcardIndex((prev) => prev + 1);
    }
    setAnswerShown(false);
  };

  return !deck ? (
    FallbackMessage({})
  ) : deck.flashcards.length == 0 ? (
    <Text>No flashcards left to study</Text>
  ) : (
    <View style={{ flex: 1, justifyContent: "space-between", margin: 30 }}>
      {currentFlashcardIndex == deck.flashcards.length ? (
        <Text>Study session finished</Text>
      ) : (
        <View style={{ flex: 1 }}>
          <ScrollView style={{ marginBottom: 30 }}>
            <View style={{ borderWidth: 2, borderRadius: 10, padding: 10 }}>
              <Text>Front: {deck.flashcards[currentFlashcardIndex].front}</Text>
              <Text>Due date: {deck.flashcards[currentFlashcardIndex].due_date.toString()}</Text>
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
                  onPress={async () => {
                    await updateFlashcardStats(
                      deck.flashcards[currentFlashcardIndex].id,
                      applySm2(deck.flashcards[currentFlashcardIndex], 1)
                    );
                    goToNextFlashcard();
                  }}
                ></CustomButton>
              </View>
              <View style={{ flex: 1 }}>
                <CustomButton
                  title={"2"}
                  color={colors.blue}
                  onPress={async () => {
                    await updateFlashcardStats(
                      deck.flashcards[currentFlashcardIndex].id,
                      applySm2(deck.flashcards[currentFlashcardIndex], 2)
                    );
                    goToNextFlashcard();
                  }}
                ></CustomButton>
              </View>
              <View style={{ flex: 1 }}>
                <CustomButton
                  title={"3"}
                  color={colors.blue}
                  onPress={async () => {
                    await updateFlashcardStats(
                      deck.flashcards[currentFlashcardIndex].id,
                      applySm2(deck.flashcards[currentFlashcardIndex], 3)
                    );
                    goToNextFlashcard();
                  }}
                ></CustomButton>
              </View>
              <View style={{ flex: 1 }}>
                <CustomButton
                  title={"4"}
                  color={colors.blue}
                  onPress={async () => {
                    await updateFlashcardStats(
                      deck.flashcards[currentFlashcardIndex].id,
                      applySm2(deck.flashcards[currentFlashcardIndex], 4)
                    );
                    goToNextFlashcard();
                  }}
                ></CustomButton>
              </View>
              <View style={{ flex: 1 }}>
                <CustomButton
                  title={"5"}
                  color={colors.blue}
                  onPress={async () => {
                    await updateFlashcardStats(
                      deck.flashcards[currentFlashcardIndex].id,
                      applySm2(deck.flashcards[currentFlashcardIndex], 5)
                    );
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
      )}
    </View>
  );
}
