import { BASE_URL } from "@/api/constants";
import { updateFlashcardStats } from "@/api/flashcards";
import CustomButton from "@/components/custom-button";
import FallbackMessage from "@/components/fallback-message";
import { useDecks } from "@/contexts/decks-context";
import { applySm2 } from "@/helpers/sm2";
import { Deck } from "@/models/deck";
import { Flashcard } from "@/models/flashcard";
import { FlashcardStatsUpdateRequest } from "@/models/flashcard-stats-update-request";
import colors from "@/styles/colors";
import { useLocalSearchParams } from "expo-router";
import { useEffect, useState } from "react";
import { Image, ScrollView, Text, View } from "react-native";

export default function StudyScreen() {
  const { deckId } = useLocalSearchParams<{ deckId: string }>();
  const { decks } = useDecks();
  const [deck, setDeck] = useState<Deck | null>(null);
  const [flashcardsToReview, setFlashcardsToReview] = useState<Flashcard[]>([]);
  const [answerShown, setAnswerShown] = useState<boolean>(false);

  useEffect(() => {
    if (!deckId) return;

    const foundDeck = decks.find((d) => d.id === Number(deckId)) ?? null;

    if (foundDeck) {
      setDeck(foundDeck);

      const dueFlashcards = foundDeck.flashcards.filter((card) => {
        const dueDate = new Date(card.due_date);
        return dueDate <= new Date();
      });

      setFlashcardsToReview(dueFlashcards);
    }
  }, [decks, deckId]);

  const rateFlashcard = async (rating: number) => {
    const ratedFlashcard = applySm2(flashcardsToReview.shift()!, rating);
    const request = new FlashcardStatsUpdateRequest(ratedFlashcard);

    await updateFlashcardStats(ratedFlashcard.id, request);

    if (rating < 4) {
      flashcardsToReview.push(ratedFlashcard);
    }

    setAnswerShown(false);
  };

  return !deck ? (
    FallbackMessage({})
  ) : flashcardsToReview.length == 0 ? (
    <Text>No flashcards left to study</Text>
  ) : (
    <View style={{ flex: 1, justifyContent: "space-between", margin: 30 }}>
      {flashcardsToReview.length === 0 ? (
        <Text>Study session finished</Text>
      ) : (
        <View style={{ flex: 1 }}>
          <ScrollView style={{ marginBottom: 30 }}>
            <View style={{ borderWidth: 2, borderRadius: 10, padding: 10 }}>
              <Text>{flashcardsToReview[0].front}</Text>
              {flashcardsToReview[0].front_image_url && (
                <Image
                  source={{
                    uri: `${BASE_URL}/${flashcardsToReview[0].front_image_url}`,
                  }}
                  style={{
                    width: "100%",
                    height: 200,
                    resizeMode: "stretch",
                    borderRadius: 10,
                    marginTop: 10,
                  }}
                />
              )}
            </View>
            <View style={{ marginTop: 10, display: answerShown ? "contents" : "none" }}>
              <Text>Answer:</Text>
              <Text>{flashcardsToReview[0].back}</Text>
              {flashcardsToReview[0].back_image_url && (
                <Image
                  source={{
                    uri: `${BASE_URL}/${flashcardsToReview[0].back_image_url}`,
                  }}
                  style={{
                    width: "100%",
                    height: 200,
                    resizeMode: "stretch",
                    borderRadius: 10,
                    marginTop: 10,
                  }}
                />
              )}
            </View>
          </ScrollView>
          {answerShown ? (
            <View style={{ alignItems: "center" }}>
              <Text style={{ fontWeight: 500, marginBottom: 15 }}>Rate your answer</Text>
              <View style={{ flexDirection: "row", justifyContent: "space-between", gap: 10 }}>
                <View style={{ flex: 1 }}>
                  <CustomButton
                    title={"1"}
                    color={colors.blue}
                    onPress={() => rateFlashcard(1)}
                  ></CustomButton>
                </View>
                <View style={{ flex: 1 }}>
                  <CustomButton
                    title={"2"}
                    color={colors.blue}
                    onPress={() => rateFlashcard(2)}
                  ></CustomButton>
                </View>
                <View style={{ flex: 1 }}>
                  <CustomButton
                    title={"3"}
                    color={colors.blue}
                    onPress={() => rateFlashcard(3)}
                  ></CustomButton>
                </View>
                <View style={{ flex: 1 }}>
                  <CustomButton
                    title={"4"}
                    color={colors.blue}
                    onPress={() => rateFlashcard(4)}
                  ></CustomButton>
                </View>
                <View style={{ flex: 1 }}>
                  <CustomButton
                    title={"5"}
                    color={colors.blue}
                    onPress={() => rateFlashcard(5)}
                  ></CustomButton>
                </View>
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
