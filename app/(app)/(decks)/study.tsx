import { BASE_URL } from "@/api/constants";
import { batchUpdateFlashcardStats } from "@/api/flashcards";
import { createStudySession } from "@/api/study-sessions";
import { getUserStats } from "@/api/users";
import CustomButton from "@/components/custom-button";
import FallbackMessage from "@/components/fallback-message";
import { useDecks } from "@/contexts/decks-context";
import { useTodaysProgress } from "@/contexts/todays-progress-context";
import { useUserStats } from "@/contexts/user-stats-context";
import { applySm2 } from "@/helpers/sm2";
import { Deck } from "@/models/deck";
import { Flashcard } from "@/models/flashcard";
import { FlashcardStatsUpdateRequest } from "@/models/flashcard-stats-update-request";
import { StudySessionCreateRequest } from "@/models/study-session-create-request";
import colors from "@/styles/colors";
import { router, useLocalSearchParams, useNavigation } from "expo-router";
import { useEffect, useLayoutEffect, useState } from "react";
import { ActionSheetIOS, Image, ScrollView, Text, TouchableOpacity, View } from "react-native";

export default function StudyScreen() {
  const { deckId } = useLocalSearchParams<{ deckId: string }>();
  const { decks } = useDecks();
  const { setUserStats } = useUserStats();
  const [deck, setDeck] = useState<Deck | null>(null);
  const [flashcardsToReview, setFlashcardsToReview] = useState<Flashcard[]>([]);
  const [reviewedFlashcards, setRevievedFlashcards] = useState<FlashcardStatsUpdateRequest[]>([]);
  const [answerShown, setAnswerShown] = useState<boolean>(false);
  const [correctAnswers, setCorrectAnswers] = useState(0);
  const [incorrectAnswers, setIncorrectAnswers] = useState(0);
  const [duration, setDuration] = useState(0);
  const navigation = useNavigation();
  const { setFlashcardsReviewedTodayCount } = useTodaysProgress();

  useLayoutEffect(() => {
    navigation.setOptions({
      headerLeft: showQuitDialog,
    });
  }, [navigation, correctAnswers, incorrectAnswers]);

  useEffect(() => {
    const interval = setInterval(() => {
      setDuration((prev) => prev + 1);
    }, 1000);

    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    if (!deckId) return;

    const foundDeck = decks.find((d) => d.id === Number(deckId)) ?? null;

    if (foundDeck) {
      setDeck(foundDeck);
      const dueFlashcards = foundDeck.flashcards.filter((card) => card.due_today);
      setFlashcardsToReview(dueFlashcards);
    }
  }, [decks, deckId]);

  const showQuitDialog = () => {
    return (
      <TouchableOpacity
        onPress={
          flashcardsToReview.length == 0
            ? () => router.back()
            : () => {
                ActionSheetIOS.showActionSheetWithOptions(
                  {
                    title: "Quit Session",
                    message: "Are you sure you want to quit this session?",
                    options: ["No", "Yes"],
                    cancelButtonIndex: 0,
                    destructiveButtonIndex: 1,
                  },
                  async (buttonIndex) => {
                    if (buttonIndex === 1) {
                      if (correctAnswers + incorrectAnswers > 0) {
                        await finishSession(correctAnswers, incorrectAnswers, reviewedFlashcards);
                      }
                      router.back();
                    }
                  }
                );
              }
        }
      >
        <Text style={{ color: "#ff2323ff", fontSize: 17, fontWeight: 500 }}>Quit session</Text>
      </TouchableOpacity>
    );
  };

  const finishSession = async (
    correctCount: number,
    incorrectCount: number,
    newReviewedFlashcards: FlashcardStatsUpdateRequest[]
  ) => {
    const studySession = new StudySessionCreateRequest({
      deck_id: Number(deckId),
      duration: duration,
      correct_answers: correctCount,
      incorrect_answers: incorrectCount,
    });

    await createStudySession(studySession);
    await batchUpdateFlashcardStats(newReviewedFlashcards);

    setFlashcardsReviewedTodayCount((prev) => prev + correctCount);

    const stats = await getUserStats();
    setUserStats(stats);
  };

  const rateFlashcard = async (rating: number) => {
    const ratedFlashcard = applySm2(flashcardsToReview.shift()!, rating);
    const request = new FlashcardStatsUpdateRequest(ratedFlashcard);

    setRevievedFlashcards((prev) => [...prev, request]);
    const newReviewedFlashcards = [...reviewedFlashcards, request];

    if (rating < 4) {
      flashcardsToReview.push(ratedFlashcard);
    }

    const newCorrect = correctAnswers + (rating >= 4 ? 1 : 0);
    const newIncorrect = incorrectAnswers + (rating < 4 ? 1 : 0);

    setCorrectAnswers(newCorrect);
    setIncorrectAnswers(newIncorrect);

    setAnswerShown(false);

    if (flashcardsToReview.length === 0) {
      await finishSession(newCorrect, newIncorrect, newReviewedFlashcards);
    }
  };

  if (!deck) {
    return FallbackMessage({});
  }

  if (flashcardsToReview.length === 0) {
    return (
      <View style={{ flex: 1, justifyContent: "center", alignItems: "center", margin: 30 }}>
        {correctAnswers + incorrectAnswers == 0 ? (
          <Text style={{ marginBottom: 20 }}>No flashcards scheduled for today.</Text>
        ) : (
          <Text style={{ marginBottom: 20 }}>All done for today!</Text>
        )}
        <View style={{ width: "100%" }}>
          <CustomButton title={"Close"} color={""} onPress={() => router.back()} icon={null} />
        </View>
      </View>
    );
  }

  return (
    <View style={{ flex: 1, justifyContent: "space-between", margin: 30 }}>
      <View style={{ flex: 1 }}>
        <ScrollView style={{ marginBottom: 30 }}>
          <View style={{ borderRadius: 10, padding: 15, backgroundColor: "#ffffff" }}>
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
          <View
            style={{
              marginTop: 20,
              backgroundColor: "#ffffff",
              borderRadius: 10,
              padding: 15,
              opacity: answerShown ? 1 : 0,
            }}
          >
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
            <Text style={{ fontWeight: "500", marginBottom: 15 }}>Rate your answer</Text>
            <View style={{ flexDirection: "row", justifyContent: "space-between", gap: 10 }}>
              {[1, 2, 3, 4, 5].map((num) => (
                <View style={{ flex: 1 }} key={num}>
                  <CustomButton
                    title={String(num)}
                    color={colors.blue}
                    onPress={() => rateFlashcard(num)}
                    icon={null}
                  />
                </View>
              ))}
            </View>
          </View>
        ) : (
          <View>
            <CustomButton
              title={"Show answer"}
              color={colors.blue}
              onPress={() => setAnswerShown(true)}
              icon={null}
            />
          </View>
        )}
      </View>
    </View>
  );
}
