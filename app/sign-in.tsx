import CustomButton from "@/components/custom-button";
import InputWrapper from "@/components/input-wrapper";
import { useSession } from "@/contexts/auth-context";
import colors from "@/styles/colors";
import { inputStyles } from "@/styles/inputs";
import FontAwesome5 from "@expo/vector-icons/FontAwesome5";
import FontAwesome6 from "@expo/vector-icons/FontAwesome6";
import Ionicons from "@expo/vector-icons/Ionicons";
import MaterialCommunityIcons from "@expo/vector-icons/MaterialCommunityIcons";
import { router } from "expo-router";
import React, { useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { ScrollView, StyleSheet, Text, TextInput, TouchableOpacity, View } from "react-native";

export default function SignIn() {
  const { signIn } = useSession();
  const [signInError, setSignInError] = useState<string | null>(null);
  const [passwordHidden, setPasswordHidden] = useState(true);

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
    } else if (result?.status == 403) {
      router.push({ pathname: "/verify-email", params: { email: data.email } });
    } else {
      setSignInError(result?.error!);
    }
  };

  const invalidCredentialsMessage = () => {
    return (
      <View
        style={{
          padding: 20,
          backgroundColor: "#f8d7d7ff",
          borderRadius: 10,
          marginBottom: 20,
        }}
      >
        <Text
          style={{
            textAlign: "center",
            color: "red",
            fontWeight: 500,
            fontSize: 16,
          }}
        >
          {signInError}
        </Text>
        <Text style={{ color: "red", marginTop: 10, textAlign: "center" }}>
          Try again with different email or password
        </Text>
      </View>
    );
  };

  return (
    <ScrollView showsVerticalScrollIndicator={false} automaticallyAdjustKeyboardInsets={true}>
      <View style={{ flex: 1, margin: 30 }}>
        <Text style={styles.title}>Welcome to Memowise!</Text>
        <Text style={styles.subtitle}>Sign in to continue.</Text>
        <View style={{ gap: 10, marginTop: 30, marginBottom: 20 }}>
          {signInError && invalidCredentialsMessage()}
          <View>
            <Text style={{ marginBottom: 8, fontWeight: "600", color: "#2c2c2cff" }}>Email</Text>
            <Controller
              control={control}
              rules={{
                required: true,
              }}
              render={({ field: { onChange, onBlur, value } }) => (
                <InputWrapper leadingIcon={<Ionicons name="mail" size={20} color={colors.blue} />}>
                  <TextInput
                    placeholder="Email"
                    placeholderTextColor={"#c6c6c6ff"}
                    keyboardType="email-address"
                    onBlur={onBlur}
                    onChangeText={onChange}
                    value={value}
                    autoCapitalize="none"
                    autoComplete="off"
                    autoCorrect={false}
                    style={inputStyles.base}
                    returnKeyType="done"
                    onSubmitEditing={handleSubmit(onSubmit)}
                  />
                </InputWrapper>
              )}
              name="email"
            />
            {errors.email && <Text style={{ marginTop: 5, color: "red" }}>Email is required.</Text>}
          </View>
          <View>
            <Text style={{ marginBottom: 8, fontWeight: "600", color: "#2c2c2cff" }}>Password</Text>

            <Controller
              control={control}
              rules={{
                required: true,
              }}
              render={({ field: { onChange, onBlur, value } }) => (
                <InputWrapper
                  leadingIcon={<FontAwesome6 name="lock" size={16} color="orange" />}
                  trailingIcon={
                    <TouchableOpacity onPress={() => setPasswordHidden((prev) => !prev)}>
                      {passwordHidden ? (
                        <FontAwesome5 name="eye" size={20} color={colors.blue} />
                      ) : (
                        <FontAwesome5 name="eye-slash" size={20} color={colors.blue} />
                      )}
                    </TouchableOpacity>
                  }
                >
                  <TextInput
                    placeholder="Password"
                    placeholderTextColor={"#c6c6c6ff"}
                    onBlur={onBlur}
                    onChangeText={onChange}
                    value={value}
                    autoCapitalize="none"
                    autoComplete="off"
                    autoCorrect={false}
                    textContentType="password"
                    style={inputStyles.base}
                    secureTextEntry={passwordHidden}
                    returnKeyType="done"
                    onSubmitEditing={handleSubmit(onSubmit)}
                  />
                </InputWrapper>
              )}
              name="password"
            />
            {errors.password && (
              <Text style={{ marginTop: 5, color: "red" }}>Password is required.</Text>
            )}
          </View>
          <TouchableOpacity onPress={() => router.push("/reset-password")}>
            <Text style={{ color: colors.blue, fontWeight: "600" }}>Reset password</Text>
          </TouchableOpacity>
        </View>
        <CustomButton
          title={"Sign in"}
          color={""}
          onPress={handleSubmit(onSubmit)}
          icon={<MaterialCommunityIcons name="login" size={18} color="white" />}
        ></CustomButton>
        <View style={{ marginTop: 30, alignItems: "center", gap: 8 }}>
          <Text style={{}}>Don't have an account?</Text>
          <TouchableOpacity onPress={() => router.replace("/sign-up")}>
            <Text
              style={{
                color: colors.blue,
                fontWeight: "600",
                backgroundColor: "#e3e3e3ff",
                paddingHorizontal: 10,
                paddingVertical: 6,
                borderRadius: 20,
              }}
            >
              Create one here!
            </Text>
          </TouchableOpacity>
        </View>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  title: {
    fontSize: 24,
    fontWeight: "bold",
    color: "#1E1E1E",
    textAlign: "center",
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 18,
    color: "#666",
    textAlign: "center",
    fontWeight: "600",
  },
});
