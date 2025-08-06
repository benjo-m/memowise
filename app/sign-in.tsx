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
      username: "",
      password: "",
    },
  });

  const _signIn = async (username: string, password: string) => {
    const result = await signIn(username, password);

    if (result.success) {
      router.replace("/");
    } else {
      setSignInError(result.error!);
    }
  };

  const onSubmit = (data: any) => _signIn(data.username, data.password);

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
            placeholder="Username"
            onBlur={onBlur}
            onChangeText={onChange}
            value={value}
            autoCapitalize="none"
            autoComplete="off"
            autoCorrect={false}
          />
        )}
        name="username"
      />
      {errors.username && <Text>Username is required.</Text>}
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
      <Button title="Log in" onPress={handleSubmit(onSubmit)} />
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
