import CustomButton from "@/components/custom-button";
import { useFlashcards } from "@/contexts/flashcards-context";
import { ImageFile } from "@/helpers/image-file";
import { pickImage } from "@/helpers/image-picker";
import { FlashcardFreshCreateRequest } from "@/models/flashcard-fresh-create-request";
import { FlashcardUpdateRequest } from "@/models/flashcard-update-request";
import { inputStyles } from "@/styles/inputs";
import { router, useLocalSearchParams } from "expo-router";
import { useEffect, useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { ActivityIndicator, Image, ScrollView, Text, TextInput, View } from "react-native";

export default function FlashcardFreshDetails() {
  const { front } = useLocalSearchParams<{ front: string }>();
  const [currentFlashcard, setCurrentFlashcard] = useState<FlashcardFreshCreateRequest>(null);
  const [loading, setLoading] = useState(true);
  const [flashcardError, setFlashcardError] = useState<string | null>(null);
  const { flashcards, setFlashcards } = useFlashcards();
  const [frontImageFile, setFrontImageFile] = useState<ImageFile | null>(null);
  const [backImageFile, setBackImageFile] = useState<ImageFile | null>(null);

  useEffect(() => {
    const found = flashcards.find((card) => card.front == front);

    if (found) {
      setCurrentFlashcard(found as FlashcardFreshCreateRequest);
      reset({ front: found.front, back: found.back });
    } else {
      setFlashcardError("Flashcard not found.");
    }

    setLoading(false);
  }, [front, flashcards]);

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

    const flashcardUpdateRequest = new FlashcardUpdateRequest(
      data.front,
      data.back,
      frontImageFile,
      backImageFile
    );

    setFlashcards((prev) =>
      prev.map((card) => (card.front === currentFlashcard.front ? flashcardUpdateRequest : card))
    );

    router.back();
  };

  return (
    <View style={{ flex: 1, margin: 30, justifyContent: "space-between" }}>
      {loading ? (
        <ActivityIndicator />
      ) : flashcardError ? (
        <Text>{flashcardError}</Text>
      ) : currentFlashcard ? (
        <View style={{ flex: 1 }}>
          <ScrollView>
            {(currentFlashcard.front_image_file || frontImageFile) && (
              <Image
                source={{
                  uri: frontImageFile ? frontImageFile.uri : currentFlashcard.front_image_file.uri,
                }}
                style={{ width: "100%", height: 200, resizeMode: "stretch" }}
              />
            )}
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
              <View style={{ marginTop: 10 }}>
                <CustomButton
                  title="Upload front image"
                  color={""}
                  onPress={() => pickImage(setFrontImageFile)}
                />
              </View>

              {errors.front && (
                <Text style={{ marginTop: 5, color: "red", textAlign: "left" }}>
                  {errors.front.message || "Front of the flashcard can't be blank."}
                </Text>
              )}
            </View>
            <View>
              {(currentFlashcard.back_image_file || backImageFile) && (
                <Image
                  source={{
                    uri: backImageFile ? backImageFile.uri : currentFlashcard.back_image_file.uri,
                  }}
                  style={{ width: "100%", height: 200, resizeMode: "stretch" }}
                />
              )}
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
              <View style={{ marginTop: 10 }}>
                <CustomButton
                  title="Upload back image"
                  color={""}
                  onPress={() => pickImage(setBackImageFile)}
                />
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
              <CustomButton title="Back" color="#1273de" onPress={() => router.back()} />
            </View>
            <View style={{ flex: 1 }}>
              <CustomButton title="Update" color="#1273de" onPress={handleSubmit(onSubmit)} />
            </View>
          </View>
        </View>
      ) : (
        <Text>Flashcard not found.</Text>
      )}
    </View>
  );
}
