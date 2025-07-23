import { createDeck } from "@/api/decks";
import CustomButton from "@/components/custom-button";
import FlashcardCard from "@/components/flashcard-card";
import { useDecks } from "@/contexts/decks-context";
import { Flashcard } from "@/models/flashcard";
import { inputStyles } from "@/styles/inputs";
import { router } from "expo-router";
import { useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { FlatList, Text, TextInput, View } from "react-native";

export default function CreateDeckScreen() {
  const { setDecks } = useDecks();
  const [flashcards, setFlashcards] = useState<Flashcard[]>([
    { id: "11111", front: "hahaa", back: "sdasd" },
  ]);

  const {
    control,
    handleSubmit,
    formState: { errors },
  } = useForm({
    defaultValues: {
      name: "",
    },
  });

  const onSubmit = async (data) => {
    try {
      const newDeck = await createDeck(data);
      setDecks((prev) => [newDeck, ...prev]);
      router.back();
    } catch (err) {
      console.error("Failed to create deck", err);
    }
  };

  return (
    <View style={{ flex: 1, alignItems: "center" }}>
      <Controller
        control={control}
        rules={{ required: true }}
        name="name"
        render={({ field: { onChange, onBlur, value } }) => (
          <TextInput
            placeholder="Name"
            onBlur={onBlur}
            onChangeText={onChange}
            value={value}
            autoCapitalize="none"
            autoComplete="off"
            autoCorrect={false}
            style={[inputStyles.base, { marginTop: 20 }]}
          />
        )}
      />
      {errors.name && <Text>Name is required.</Text>}
      <Text style={{ marginTop: 20 }}>Flashcards</Text>
      <FlatList
        data={flashcards}
        keyExtractor={({ id }) => id}
        renderItem={({ item }) => (
          <FlashcardCard front={item.back}></FlashcardCard>
        )}
        style={{ width: "100%" }}
      />

      <View
        style={{
          flexDirection: "row",
          justifyContent: "space-around",
          gap: 12,
          marginBottom: 20,
          width: "90%",
        }}
      >
        <View style={{ flex: 1 }}>
          <CustomButton title="Add flashcard" color="#1273de" onPress={null} />
        </View>
        <View style={{ flex: 1 }}>
          <CustomButton
            title="Create deck"
            color="#1273de"
            onPress={handleSubmit(onSubmit)}
          />
        </View>
      </View>
    </View>
  );
}
