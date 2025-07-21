import { createDeck } from "@/api/decks";
import { useDecks } from "@/contexts/decks-context";
import { router } from "expo-router";
import { Controller, useForm } from "react-hook-form";
import { Button, Text, TextInput, View } from "react-native";

export default function CreateDeckScreen() {
  const { setDecks } = useDecks();

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
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Controller
        control={control}
        rules={{ required: true }}
        render={({ field: { onChange, onBlur, value } }) => (
          <TextInput
            placeholder="Name"
            onBlur={onBlur}
            onChangeText={onChange}
            value={value}
            autoCapitalize="none"
            autoComplete="off"
            autoCorrect={false}
          />
        )}
        name="name"
      />
      {errors.name && <Text>Name is required.</Text>}
      <Button title="Create deck" onPress={handleSubmit(onSubmit)} />
    </View>
  );
}
