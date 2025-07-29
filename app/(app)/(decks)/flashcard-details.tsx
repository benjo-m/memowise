import { BASE_URL } from "@/api/constants";
import { deleteFlashcard, updateFlashcard } from "@/api/flashcards";
import CustomButton from "@/components/custom-button";
import { useDecks } from "@/contexts/decks-context";
import { useFlashcards } from "@/contexts/flashcards-context";
import { ImageFile } from "@/helpers/image-file";
import { pickImage } from "@/helpers/image-picker";
import { Flashcard } from "@/models/flashcard";
import { FlashcardUpdateRequest } from "@/models/flashcard-update-request";
import colors from "@/styles/colors";
import { inputStyles } from "@/styles/inputs";
import { router, useLocalSearchParams } from "expo-router";
import { useEffect, useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { ActivityIndicator, Alert, Image, ScrollView, Text, TextInput, View } from "react-native";

export default function FlashcardDetails() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const [currentFlashcard, setCurrentFlashcard] = useState<Flashcard>();
  const [loading, setLoading] = useState(true);
  const [flashcardError, setFlashcardError] = useState<string | null>(null);
  const { flashcards, setFlashcards } = useFlashcards();
  const { setDecks } = useDecks();
  const [frontImageFile, setFrontImageFile] = useState<ImageFile | null>(null);
  const [backImageFile, setBackImageFile] = useState<ImageFile | null>(null);

  useEffect(() => {
    const found = flashcards.find((card) => card.id == id);

    if (found) {
      setCurrentFlashcard(found as Flashcard);
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
    const duplicate = flashcards.some(
      (card) => card.front === data.front && card.front !== currentFlashcard.front
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
        data.back,
        frontImageFile,
        backImageFile
      );

      const updated = await updateFlashcard(currentFlashcard.id, flashcardUpdateRequest);

      setFlashcards((prev) =>
        prev.map((card) => (card.id === currentFlashcard.id ? updated : card))
      );

      setDecks((prevDecks) =>
        prevDecks.map((deck) => {
          if (deck.id === Number(currentFlashcard.deck_id)) {
            const updatedFlashcards = deck.flashcards.map((card) =>
              card.id === currentFlashcard.id ? updated : card
            );
            const updatedDeck = { ...deck, flashcards: updatedFlashcards };
            return updatedDeck;
          }

          return deck;
        })
      );
      router.back();
    } catch (err) {
      console.error("Failed to update flashcard:", err);
    }
  };

  const handleDeleteFlashcard = async (flashcard: Flashcard) => {
    try {
      await deleteFlashcard(flashcard.id);
      setFlashcards((prev) => prev.filter((card) => card.id !== flashcard.id));
      setDecks((prevDecks) =>
        prevDecks.map((deck) =>
          deck.id === Number(flashcard.deck_id)
            ? {
                ...deck,
                flashcards: deck.flashcards.filter((c) => c.id !== flashcard.id),
              }
            : deck
        )
      );
    } catch (err) {
      console.error("Failed to delete flashcard:", err);
    }
  };

  return (
    <View style={{ flex: 1, margin: 30, justifyContent: "space-between" }}>
      {loading ? (
        <ActivityIndicator />
      ) : flashcardError ? (
        <Text>{flashcardError}</Text>
      ) : currentFlashcard ? (
        <View style={{ flex: 1 }}>
          <ScrollView showsVerticalScrollIndicator={false}>
            <View style={{ marginBottom: 50 }}>
              <Text style={{ fontWeight: 500, marginBottom: 5, marginLeft: 2, fontSize: 16 }}>
                Front
              </Text>
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
              {(currentFlashcard.front_image_url || frontImageFile) && (
                <Image
                  source={{
                    uri: frontImageFile
                      ? frontImageFile.uri
                      : `${BASE_URL}/${currentFlashcard.front_image_url}`,
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

              <View style={{ marginTop: 10, width: "100%" }}>
                {currentFlashcard.front_image_url && !frontImageFile ? (
                  <CustomButton
                    title="Remove front image"
                    color={colors.red}
                    onPress={() => {
                      currentFlashcard.front_image_url = null;
                      setFrontImageFile(null);
                    }}
                  />
                ) : (
                  <CustomButton
                    title="Upload front image"
                    color={colors.blue}
                    onPress={() => pickImage(setFrontImageFile)}
                  />
                )}
              </View>

              {errors.front && (
                <Text style={{ marginTop: 5, color: "red", textAlign: "left" }}>
                  {errors.front.message || "Front of the flashcard can't be blank."}
                </Text>
              )}
            </View>
            <View style={{ marginBottom: 50 }}>
              <Text style={{ fontWeight: 500, marginBottom: 5, marginLeft: 2, fontSize: 16 }}>
                Back
              </Text>
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
              {(currentFlashcard.back_image_url || backImageFile) && (
                <Image
                  source={{
                    uri: backImageFile
                      ? backImageFile.uri
                      : `${BASE_URL}/${currentFlashcard.back_image_url}`,
                  }}
                  style={{
                    width: "100%",
                    height: 200,
                    resizeMode: "stretch",
                    marginTop: 10,
                    borderRadius: 10,
                  }}
                />
              )}
              <View style={{ marginTop: 10, width: "100%" }}>
                {currentFlashcard.back_image_url ? (
                  <CustomButton
                    title="Remove back image"
                    color={colors.red}
                    onPress={() => {
                      currentFlashcard.back_image_url = null;
                      setBackImageFile(null);
                    }}
                  />
                ) : (
                  <CustomButton
                    title="Upload back image"
                    color={colors.blue}
                    onPress={() => pickImage(setBackImageFile)}
                  />
                )}
              </View>
              {errors.back && (
                <Text style={{ marginTop: 5, color: "red", textAlign: "left" }}>
                  Back of the flashcard can't be blank.
                </Text>
              )}
            </View>
          </ScrollView>
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
                title="Delete"
                color={colors.red}
                onPress={() => {
                  Alert.alert(
                    "Delete flashcard",
                    "Are you sure you want to delete this flashcard?",
                    [
                      { text: "Cancel", style: "cancel" },
                      {
                        text: "Delete",
                        style: "destructive",
                        onPress: async () => {
                          await handleDeleteFlashcard(currentFlashcard);
                          router.back();
                        },
                      },
                    ],
                    { cancelable: true }
                  );
                }}
              />
            </View>
            <View style={{ flex: 1 }}>
              <CustomButton title="Update" color={colors.blue} onPress={handleSubmit(onSubmit)} />
            </View>
          </View>
        </View>
      ) : (
        <Text>Flashcard not found.</Text>
      )}
    </View>
  );
}
