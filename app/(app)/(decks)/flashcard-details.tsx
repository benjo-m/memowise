import { updateFlashcard } from "@/api/flashcards";
import CustomButton from "@/components/custom-button";
import { useDecks } from "@/contexts/decks-context";
import { useFlashcards } from "@/contexts/flashcards-context";
import { Flashcard } from "@/models/flashcard";
import { FlashcardUpdateRequest } from "@/models/flashcard-update-request";
import { inputStyles } from "@/styles/inputs";
import { router, useLocalSearchParams } from "expo-router";
import { useEffect, useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { ActivityIndicator, Text, TextInput, View } from "react-native";

export default function FlashcardDetails() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const [currentFlashcard, setCurrentFlashcard] = useState<Flashcard | null>(
    null
  );
  const [loading, setLoading] = useState(true);
  const [flashcardError, setFlashcardError] = useState<string | null>(null);
  const { flashcards, setFlashcards } = useFlashcards();
  const { decks, setDecks } = useDecks();

  useEffect(() => {
    if (!id) return;

    const found = flashcards.find((card) => card.id == id);

    if (found) {
      setCurrentFlashcard(found);
      reset({ front: found.front, back: found.back });
    } else {
      setFlashcardError("Flashcard not found.");
    }

    setLoading(false);
  }, [id, flashcards]);

  const {
    control,
    handleSubmit,
    reset,
    setError,
    formState: { errors },
  } = useForm({
    defaultValues: {
      front: "",
      back: "",
    },
  });

  const onSubmit = async (data) => {
    if (!currentFlashcard) return;

    const duplicate = flashcards.some(
      (card) => card.front === data.front && card.id !== currentFlashcard.id
    );

    if (duplicate) {
      setError("front", {
        type: "manual",
        message: "Duplicate",
      });
      return;
    }

    try {
      const flashcardUpdateRequest = new FlashcardUpdateRequest(
        data.front,
        data.back
      );

      const updated = await updateFlashcard(
        currentFlashcard.id,
        flashcardUpdateRequest
      );

      setFlashcards((prev) =>
        prev.map((card) => (card.id === currentFlashcard.id ? updated : card))
      );

      setDecks((prevDecks) =>
        prevDecks.map((deck) =>
          deck.id === Number(currentFlashcard.deck_id)
            ? {
                ...deck,
                flashcards: deck.flashcards.map((card) =>
                  card.id === currentFlashcard.id ? updated : card
                ),
              }
            : deck
        )
      );

      router.back();
    } catch (err) {
      console.error("Failed to update flashcard:", err);
    }
  };

  return (
    <View style={{ flex: 1, margin: 30, justifyContent: "space-between" }}>
      {loading ? (
        <ActivityIndicator />
      ) : flashcardError ? (
        <Text>{flashcardError}</Text>
      ) : currentFlashcard ? (
        <View style={{ flex: 1, justifyContent: "space-between" }}>
          <View style={{ gap: 16 }}>
            <View>
              <Controller
                control={control}
                rules={{ required: true }}
                name="front"
                render={({ field: { onChange, onBlur, value } }) => (
                  <TextInput
                    placeholder="Front of the flashcard"
                    onBlur={onBlur}
                    onChangeText={onChange}
                    value={value}
                    autoCapitalize="none"
                    autoComplete="off"
                    autoCorrect={false}
                    style={inputStyles.base}
                  />
                )}
              />
              {errors.front && (
                <Text style={{ marginTop: 5, color: "red", textAlign: "left" }}>
                  {errors.front.message ||
                    "Front of the flashcard can't be blank."}
                </Text>
              )}
            </View>
            <View>
              <Controller
                control={control}
                rules={{ required: true }}
                name="back"
                render={({ field: { onChange, onBlur, value } }) => (
                  <TextInput
                    placeholder="Back of the flashcard"
                    onBlur={onBlur}
                    onChangeText={onChange}
                    value={value}
                    autoCapitalize="none"
                    autoComplete="off"
                    autoCorrect={false}
                    style={inputStyles.base}
                  />
                )}
              />
              {errors.back && (
                <Text style={{ marginTop: 5, color: "red", textAlign: "left" }}>
                  Back of the flashcard can't be blank.
                </Text>
              )}
            </View>
          </View>
          <View
            style={{
              flexDirection: "row",
              justifyContent: "space-between",
              gap: 16,
              marginTop: 20,
            }}
          >
            <View style={{ flex: 1 }}>
              <CustomButton
                title="Back"
                color="#1273de"
                onPress={() => router.back()}
              />
            </View>
            <View style={{ flex: 1 }}>
              <CustomButton
                title="Update"
                color="#1273de"
                onPress={handleSubmit(onSubmit)}
              />
            </View>
          </View>
        </View>
      ) : (
        <Text>Flashcard not found.</Text>
      )}
    </View>
  );
}
