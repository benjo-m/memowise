import { changeEmail } from "@/api/auth";
import CustomButton from "@/components/custom-button";
import InputWrapper from "@/components/input-wrapper";
import colors from "@/styles/colors";
import { inputStyles } from "@/styles/inputs";
import FontAwesome5 from "@expo/vector-icons/FontAwesome5";
import FontAwesome6 from "@expo/vector-icons/FontAwesome6";
import Ionicons from "@expo/vector-icons/Ionicons";
import { router } from "expo-router";
import { useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { Alert, Text, TextInput, TouchableOpacity, View } from "react-native";

export default function ChangeEmailScreen() {
  const [passwordHidden, setPasswordHidden] = useState(true);

  const {
    control,
    handleSubmit,
    setError,
    formState: { errors },
  } = useForm({
    defaultValues: {
      email: "",
      password: "",
    },
  });

  const onSubmit = async (data: any) => {
    try {
      await changeEmail({
        email: data.email,
        password: data.password,
      });
      Alert.alert(
        "Verification email sent",
        "Verification email has been sent to your new email address.",
        [
          {
            text: "OK",
            onPress: () => router.back(),
          },
        ]
      );
    } catch (err: any) {
      if (err["field-error"]) {
        const errorField = err["field-error"][0];
        const errorMessage = err["field-error"][1];
        setError(errorField, { type: "manual", message: errorMessage });
      } else if (err.error) {
        setError("email", { type: "manual", message: err.error });
      } else {
        setError("email", { type: "manual", message: "An unknown error occurred" });
      }
    }
  };

  return (
    <View style={{ flex: 1, margin: 30 }}>
      <Text
        style={{
          fontSize: 16,
          color: "#1E1E1E",
          textAlign: "center",
          fontWeight: "600",
        }}
      >
        Enter your new email and current password below
      </Text>
      <View style={{ gap: 10, marginTop: 30, marginBottom: 20 }}>
        <View>
          <Text style={{ marginBottom: 8, fontWeight: "600", color: "#2c2c2cff" }}>New email</Text>
          <Controller
            control={control}
            rules={{
              required: "Email is required",
            }}
            render={({ field: { onChange, onBlur, value } }) => (
              <InputWrapper leadingIcon={<Ionicons name="mail" size={20} color={colors.blue} />}>
                <TextInput
                  placeholder="Email"
                  onBlur={onBlur}
                  onChangeText={onChange}
                  value={value}
                  autoCapitalize="none"
                  autoComplete="off"
                  autoCorrect={false}
                  style={inputStyles.base}
                />
              </InputWrapper>
            )}
            name="email"
          />
          {errors.email && (
            <Text style={{ marginTop: 5, color: "red" }}>{errors.email.message}</Text>
          )}
        </View>
        <View>
          <Text style={{ marginBottom: 8, fontWeight: "600", color: "#2c2c2cff" }}>Password</Text>
          <Controller
            control={control}
            rules={{
              required: "Password is required",
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
                  onBlur={onBlur}
                  onChangeText={onChange}
                  value={value}
                  autoCapitalize="none"
                  autoComplete="off"
                  autoCorrect={false}
                  style={inputStyles.base}
                  secureTextEntry={passwordHidden}
                />
              </InputWrapper>
            )}
            name="password"
          />
          {errors.password && (
            <Text style={{ marginTop: 5, color: "red" }}>{errors.password.message}</Text>
          )}
        </View>
      </View>
      <CustomButton
        title={"Done"}
        color={""}
        onPress={handleSubmit(onSubmit)}
        icon={<FontAwesome5 name="check" size={18} color="white" />}
      ></CustomButton>
    </View>
  );
}
