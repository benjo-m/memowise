import CustomButton from "@/components/custom-button";
import { useFlashcards } from "@/contexts/flashcards-context";
import { inputStyles } from "@/styles/inputs";
import { router } from "expo-router";
import React from "react";
import { Controller, useForm } from "react-hook-form";
import { Text, TextInput, View } from "react-native";

export default function AddFlashcardsScreen() {
  const { flashcards, setFlashcards } = useFlashcards();

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

  const onSubmit = (data) => {
    const exists = flashcards.some((card) => card.front === data.front);

    if (exists) {
      setError("front", {
        type: "manual",
        message: "Duplicate",
      });

      return;
    }

    setFlashcards([data, ...flashcards]);
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
