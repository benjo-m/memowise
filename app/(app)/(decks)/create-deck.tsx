import { createDeck } from "@/api/decks";
import CustomButton from "@/components/custom-button";
import FlashcardCard from "@/components/flashcard-card";
import { useDecks } from "@/contexts/decks-context";
import { useFlashcards } from "@/contexts/flashcards-context";
import { CreateDeckRequest } from "@/models/create-deck-request";
import { inputStyles } from "@/styles/inputs";
import { router } from "expo-router";
import { Controller, useForm } from "react-hook-form";
import { FlatList, Text, TextInput, View } from "react-native";

export default function CreateDeckScreen() {
  const { setDecks } = useDecks();
  const { flashcards } = useFlashcards();

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
      const createDeckRequest = new CreateDeckRequest(data.name, flashcards);
      const newDeck = await createDeck(createDeckRequest);
      setDecks((prev) => [newDeck, ...prev]);
      router.back();
    } catch (err) {
      console.error("Failed to create deck", err);
    }
  };

  return (
    <View style={{ flex: 1, alignItems: "center", margin: 20 }}>
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
            style={inputStyles.base}
          />
        )}
      />
      {errors.name && (
        <Text style={{ marginTop: 5, color: "red", textAlign: "left" }}>
          Name is required.
        </Text>
      )}
      <Text style={{ marginTop: 20 }}>Flashcards</Text>
      <FlatList
        data={flashcards}
        keyExtractor={(item) => item.front}
        renderItem={({ item }) => (
          <FlashcardCard front={item.front}></FlashcardCard>
        )}
        style={{ width: "100%" }}
      />

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
            title="Add flashcard"
            color="#1273de"
            onPress={() => router.navigate("/add-flashcards")}
          />
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
