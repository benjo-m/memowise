import { createFlashcard } from "@/api/flashcards";
import CustomButton from "@/components/custom-button";
import { useDecks } from "@/contexts/decks-context";
import { useFlashcards } from "@/contexts/flashcards-context";
import { FlashcardCreateRequest } from "@/models/flashcard-create-request";
import { inputStyles } from "@/styles/inputs";
import { router, useLocalSearchParams } from "expo-router";
import React, { useEffect } from "react";
import { Controller, useForm } from "react-hook-form";
import { Text, TextInput, View } from "react-native";

export default function AddFlashcardsScreen() {
  const { deckId } = useLocalSearchParams<{ deckId: string }>();
  const { decks, setDecks } = useDecks();
  const { flashcards, setFlashcards } = useFlashcards();
  const deck = decks.find((d) => d.id === Number(deckId)) ?? null;

  useEffect(() => {
    if (deck) {
      setFlashcards(deck.flashcards);
    } else {
      setFlashcards([]);
    }
  }, [deck]);

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
    const exists = flashcards.some((card) => card.front === data.front);

    if (exists) {
      setError("front", {
        type: "manual",
        message: "Duplicate",
      });
      return;
    }

    if (deck) {
      const flashcardCreateRequest = new FlashcardCreateRequest(
        deck.id,
        data.front,
        data.back
      );
      const newFlashcard = await createFlashcard(flashcardCreateRequest);

      setFlashcards([newFlashcard, ...flashcards]);

      setDecks((prevDecks) =>
        prevDecks.map((d) =>
          d.id === deck.id
            ? { ...d, flashcards: [newFlashcard, ...d.flashcards] }
            : d
        )
      );
    } else {
      setFlashcards([data, ...flashcards]);
    }

    reset({ front: "", back: "" });
  };

  return (
    <View style={{ flex: 1, margin: 30, justifyContent: "space-between" }}>
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
              {errors.front.message || "Front of the flashcard can't be blank."}
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
            title="Add"
            color="#1273de"
            onPress={handleSubmit(onSubmit)}
          />
        </View>
      </View>
    </View>
  );
}
