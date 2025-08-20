import { Button, SafeAreaView, StyleSheet, Text, TextInput } from "react-native";

import { useSession } from "@/contexts/auth-context";
import { router } from "expo-router";
import React, { useState } from "react";
import { Controller, useForm } from "react-hook-form";

export default function SignIn() {
  const { signIn } = useSession();
  const [signInError, setSignInError] = useState<string | null>(null);

  const {
    control,
    handleSubmit,
    formState: { errors },
  } = useForm({
    defaultValues: {
      email: "",
      password: "",
    },
  });

  const onSubmit = async (data: any) => {
    const result = await signIn(data.email, data.password);

    if (result?.success) {
      router.replace("/");
    } else {
      setSignInError(result?.error!);
    }
  };

  return (
    <SafeAreaView style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      {signInError && <Text>{signInError}</Text>}
      <Controller
        control={control}
        rules={{
          required: true,
        }}
        render={({ field: { onChange, onBlur, value } }) => (
          <TextInput
            placeholder="Email"
            onBlur={onBlur}
            onChangeText={onChange}
            value={value}
            autoCapitalize="none"
            autoComplete="off"
            autoCorrect={false}
          />
        )}
        name="email"
      />
      {errors.email && <Text>Email is required.</Text>}
      <Controller
        control={control}
        rules={{
          required: true,
        }}
        render={({ field: { onChange, onBlur, value } }) => (
          <TextInput
            placeholder="Password"
            onBlur={onBlur}
            onChangeText={onChange}
            value={value}
            autoCapitalize="none"
            autoComplete="off"
            autoCorrect={false}
            textContentType="password"
          />
        )}
        name="password"
      />
      {errors.password && <Text>Password is required.</Text>}
      <Button title="Sign in" onPress={handleSubmit(onSubmit)} />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  textInput: {
    borderWidth: 1,
    borderRadius: 5,
    borderColor: "gray",
    padding: 10,
    width: "70%",
  },
});
