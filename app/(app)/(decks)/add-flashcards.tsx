import { createFlashcard } from "@/api/flashcards";
import CustomButton from "@/components/custom-button";
import { useDecks } from "@/contexts/decks-context";
import { useFlashcards } from "@/contexts/flashcards-context";
import { ImageFile } from "@/helpers/image-file";
import { pickImage } from "@/helpers/image-picker";
import { FlashcardCreateRequest } from "@/models/flashcard-create-request";
import colors from "@/styles/colors";
import { inputStyles } from "@/styles/inputs";
import { router, useLocalSearchParams } from "expo-router";
import React, { useEffect, useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { Image, ScrollView, Text, TextInput, View } from "react-native";

export default function AddFlashcardsScreen() {
  const { deckId } = useLocalSearchParams<{ deckId: string }>();
  const { decks, setDecks } = useDecks();
  const { flashcards, setFlashcards } = useFlashcards();
  const deck = decks.find((d) => d.id === Number(deckId)) ?? null;
  const [frontImageFile, setFrontImageFile] = useState<ImageFile | null>(null);
  const [backImageFile, setBackImageFile] = useState<ImageFile | null>(null);

  useEffect(() => {
    if (deck) setFlashcards(deck.flashcards);
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
    const duplicate = flashcards.some((card) => card.front === data.front);

    if (duplicate) {
      setError("front", {
        type: "manual",
        message: "Duplicate",
      });
      return;
    }

    const flashcardCreateRequest = new FlashcardCreateRequest(
      deck.id,
      data.front,
      data.back,
      frontImageFile,
      backImageFile
    );

    const newFlashcard = await createFlashcard(flashcardCreateRequest);

    setFlashcards([newFlashcard, ...flashcards]);

    setDecks((prevDecks) =>
      prevDecks.map((d) =>
        d.id === deck.id ? { ...d, flashcards: [newFlashcard, ...d.flashcards] } : d
      )
    );

    reset({ front: "", back: "" });
    setFrontImageFile(null);
    setBackImageFile(null);
  };

  return (
    <View style={{ flex: 1, margin: 30, justifyContent: "space-between" }}>
      <View
        style={{
          flex: 1,
          gap: "5%",
        }}
      >
        <ScrollView>
          <View style={{ marginBottom: 30 }}>
            <Text>Front</Text>
            <Controller
              control={control}
              rules={{ required: true }}
              name="front"
              render={({ field: { onChange, onBlur, value } }) => (
                <TextInput
                  placeholder="Front of the flashcard"
                  multiline
                  onBlur={onBlur}
                  onChangeText={onChange}
                  value={value}
                  autoCapitalize="none"
                  autoComplete="off"
                  autoCorrect={false}
                  style={[inputStyles.base, { height: 100 }]}
                />
              )}
            />
            {frontImageFile && (
              <Image
                source={{
                  uri: frontImageFile.uri,
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
            {errors.front && (
              <Text
                style={{
                  marginTop: 5,
                  color: "red",
                  textAlign: "left",
                  marginLeft: 2,
                  fontWeight: 500,
                }}
              >
                {errors.front.message || "Front of the flashcard can't be blank."}
              </Text>
            )}
            <View style={{ marginTop: 10 }}>
              {frontImageFile ? (
                <CustomButton
                  title="Remove front image"
                  color={colors.red}
                  onPress={() => setFrontImageFile(null)}
                />
              ) : (
                <CustomButton
                  title="Upload front image"
                  color={colors.blue}
                  onPress={() => pickImage(setFrontImageFile)}
                />
              )}
            </View>
          </View>
          <View style={{ marginBottom: 30 }}>
            <Text>Back</Text>
            <Controller
              control={control}
              rules={{ required: true }}
              name="back"
              render={({ field: { onChange, onBlur, value } }) => (
                <TextInput
                  placeholder="Back of the flashcard"
                  multiline
                  onBlur={onBlur}
                  onChangeText={onChange}
                  value={value}
                  autoCapitalize="none"
                  autoComplete="off"
                  autoCorrect={false}
                  style={[inputStyles.base, { height: 100 }]}
                />
              )}
            />
            {errors.back && (
              <Text style={{ marginTop: 5, color: "red", textAlign: "left" }}>
                Back of the flashcard can't be blank.
              </Text>
            )}
            {backImageFile?.uri && (
              <Image
                source={{
                  uri: backImageFile.uri,
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
            <View style={{ marginTop: 10 }}>
              {backImageFile ? (
                <CustomButton
                  title="Remove back image"
                  color={colors.red}
                  onPress={() => setBackImageFile(null)}
                />
              ) : (
                <CustomButton
                  title="Upload back image"
                  color={colors.blue}
                  onPress={() => pickImage(setBackImageFile)}
                />
              )}
            </View>
          </View>
        </ScrollView>
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
          <CustomButton title="Back" color={colors.blue} onPress={() => router.back()} />
        </View>
        <View style={{ flex: 1 }}>
          <CustomButton title="Add" color={colors.blue} onPress={handleSubmit(onSubmit)} />
        </View>
      </View>
    </View>
  );
}
