import { BASE_URL } from "@/api/constants";
import { deleteFlashcard, updateFlashcard } from "@/api/flashcards";
import CustomButton from "@/components/custom-button";
import FallbackMessage from "@/components/fallback-message";
import { useDecks } from "@/contexts/decks-context";
import { useTodaysProgress } from "@/contexts/todays-progress-context";
import { ImageFile } from "@/helpers/image-file";
import { pickImage } from "@/helpers/image-picker";
import { Deck } from "@/models/deck";
import { Flashcard } from "@/models/flashcard";
import { FlashcardUpdateRequest } from "@/models/flashcard-update-request";
import colors from "@/styles/colors";
import { inputStyles } from "@/styles/inputs";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import FontAwesome6 from "@expo/vector-icons/FontAwesome6";
import { router, useLocalSearchParams } from "expo-router";
import { useEffect, useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { ActionSheetIOS, Alert, Image, ScrollView, Text, TextInput, View } from "react-native";

export default function FlashcardDetails() {
  const { flashcardId, deckId } = useLocalSearchParams<{ flashcardId: string; deckId: string }>();
  const [currentFlashcard, setCurrentFlashcard] = useState<Flashcard>();
  const [deck, setDeck] = useState<Deck>();
  const { decks, setDecks } = useDecks();
  const [frontImageFile, setFrontImageFile] = useState<ImageFile | null>(null);
  const [backImageFile, setBackImageFile] = useState<ImageFile | null>(null);
  const { setFlashcardsDueTodayCount } = useTodaysProgress();

  useEffect(() => {
    if (!deckId || !flashcardId) return;

    const deck = decks.find((deck) => deck.id === Number(deckId));
    const flashcard = deck?.flashcards.find((flashcard) => flashcard.id === Number(flashcardId));

    if (flashcard) {
      setDeck(deck);
      setCurrentFlashcard(flashcard);
      reset({ front: flashcard.front, back: flashcard.back });
    }
  }, []);

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

  const onSubmit = async (data: any) => {
    const duplicate = deck!.flashcards.some(
      (card) => card.front === data.front && card.front !== currentFlashcard!.front
    );

    if (duplicate) {
      setError("front", {
        type: "manual",
        message: "Duplicate",
      });
      return;
    }

    try {
      const flashcardUpdateRequest = new FlashcardUpdateRequest({
        front: data.front,
        back: data.back,
        front_image_file: frontImageFile,
        back_image_file: backImageFile,
        remove_front_image: currentFlashcard?.front_image_url === null && frontImageFile === null,
        remove_back_image: currentFlashcard?.back_image_url === null && backImageFile === null,
      });

      const updated = await updateFlashcard(currentFlashcard!.id, flashcardUpdateRequest);

      setDecks((prevDecks) =>
        prevDecks.map((deck) => {
          if (deck.id === currentFlashcard!.deck_id) {
            const updatedFlashcards = deck.flashcards.map((card) =>
              card.id === currentFlashcard!.id ? updated : card
            );
            const updatedDeck = { ...deck, flashcards: updatedFlashcards };
            return updatedDeck;
          }

          return deck;
        })
      );
      router.back();
    } catch (err) {
      err instanceof Error && Alert.alert("Failed to update flashcard", err.message);
    }
  };

  const handleDeleteFlashcard = async (flashcard: Flashcard) => {
    try {
      await deleteFlashcard(flashcard.id);
      setDecks((prevDecks) =>
        prevDecks.map((deck) =>
          deck.id === flashcard.deck_id
            ? {
                ...deck,
                flashcards: deck.flashcards.filter((c) => c.id !== flashcard.id),
              }
            : deck
        )
      );

      if (flashcard.due_today) {
        setFlashcardsDueTodayCount((prev) => prev - 1);
      }

      router.back();
    } catch (err) {
      err instanceof Error && Alert.alert("Failed to delete flashcard", err.message);
    }
  };

  return !deck ? (
    FallbackMessage({})
  ) : (
    <ScrollView
      showsVerticalScrollIndicator={false}
      automaticallyAdjustKeyboardInsets={true}
      contentContainerStyle={{ flexGrow: 1, margin: 30 }}
    >
      <View style={{ flex: 1 }}>
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
                placeholderTextColor={"#c6c6c6ff"}
                multiline
                onBlur={onBlur}
                onChangeText={onChange}
                value={value}
                autoCapitalize="none"
                autoComplete="off"
                autoCorrect={false}
                numberOfLines={5}
                style={inputStyles.base}
              />
            )}
          />
          {(currentFlashcard?.front_image_url !== null || frontImageFile !== null) && (
            <Image
              source={{
                uri: frontImageFile
                  ? frontImageFile.uri
                  : `${BASE_URL}/${currentFlashcard?.front_image_url}`,
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
            {currentFlashcard?.front_image_url || frontImageFile ? (
              <CustomButton
                title="Remove front image"
                color={colors.red}
                onPress={() => {
                  setCurrentFlashcard((prev) =>
                    prev
                      ? {
                          ...prev,
                          front_image_url: null,
                        }
                      : prev
                  );
                  setFrontImageFile(null);
                }}
                icon={<FontAwesome name="remove" size={18} color="white" />}
              />
            ) : (
              <CustomButton
                title="Upload front image"
                color={colors.blue}
                onPress={() => pickImage(setFrontImageFile)}
                icon={<FontAwesome6 name="image" size={18} color="white" />}
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
                placeholderTextColor={"#c6c6c6ff"}
                multiline
                numberOfLines={5}
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
          {(currentFlashcard?.back_image_url || backImageFile) && (
            <Image
              source={{
                uri: backImageFile
                  ? backImageFile.uri
                  : `${BASE_URL}/${currentFlashcard?.back_image_url}`,
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
            {currentFlashcard?.back_image_url || backImageFile ? (
              <CustomButton
                title="Remove back image"
                color={colors.red}
                onPress={() => {
                  setCurrentFlashcard((prev) =>
                    prev
                      ? {
                          ...prev,
                          back_image_url: null,
                        }
                      : prev
                  );
                  setBackImageFile(null);
                }}
                icon={<FontAwesome name="remove" size={18} color="white" />}
              />
            ) : (
              <CustomButton
                title="Upload back image"
                color={colors.blue}
                onPress={() => pickImage(setBackImageFile)}
                icon={<FontAwesome6 name="image" size={18} color="white" />}
              />
            )}
          </View>
          {errors.back && (
            <Text style={{ marginTop: 5, color: "red", textAlign: "left" }}>
              Back of the flashcard can't be blank.
            </Text>
          )}
        </View>
      </View>
      {/* -------- BUTTONS VIEW ----------- */}
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
              ActionSheetIOS.showActionSheetWithOptions(
                {
                  title: "Delete flashcard",
                  message: "Are you sure you want to delete this flashcard?",
                  options: ["Cancel", "Delete"],
                  destructiveButtonIndex: 1,
                  cancelButtonIndex: 0,
                },
                async (buttonIndex) => {
                  if (buttonIndex === 1) {
                    await handleDeleteFlashcard(currentFlashcard!);
                  }
                }
              );
            }}
            icon={<FontAwesome6 name="trash" size={18} color="white" />}
          />
        </View>
        <View style={{ flex: 1 }}>
          <CustomButton
            title="Update"
            color={colors.blue}
            onPress={handleSubmit(onSubmit)}
            icon={<FontAwesome name="check" size={18} color="white" />}
          />
        </View>
      </View>
    </ScrollView>
  );
}
